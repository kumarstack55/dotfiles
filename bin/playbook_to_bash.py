#!/usr/bin/env python3
from abc import ABC
from typing import List
from textwrap import dedent
import argparse
import copy
import json
import re


class Module(ABC):
    def get_module_name(self) -> str:
        return re.sub(r'^Module', '', self.__class__.__name__)

    def get_func(self) -> str:
        raise NotImplementedError()

    def get_cmd(self) -> str:
        raise NotImplementedError()


class ModuleSymlink(Module):
    def __init__(self, path=None, src=None, force=False):
        self._path = path
        self._src = src
        self._froce = force

    @property
    def path(self):
        return self._path

    @property
    def src(self):
        return self._src

    @property
    def force(self):
        return self.force

    def get_func(self):
        return dedent('''\
          module_symlink() {
            local src="$1" path="$2"
            local target
            if [ ! -f "$src" ]; then
              echo "No such file or directory: $src"
              return 1
            fi
            target=$(readlink -f "$src")
            if should_process "make symlink" "$target --> $path"; then
              ln -fnsv "$target" "$path"
            fi
          }''')

    def get_cmd(self) -> str:
        return dedent(f'module_symlink "{self.src}" "{self.path}"')


class ModuleDirectory(Module):
    def __init__(self, path=None, mode=None):
        self._path = path
        self._mode = mode

    @property
    def path(self):
        return self._path

    @property
    def mode(self):
        return self._mode

    def get_func(self):
        return dedent('''\
          module_directory() {
            local path="$1" mode="$2"
            if should_process "mkdir" "$path"; then
              mkdir -pv "$path"
            fi
            if [ "${mode+x}" ]; then
              if should_process "chmod" "mode: $mode, path: $path"; then
                chmod -v "$mode" "$path"
              fi
            fi
          }''')

    def get_cmd(self) -> str:
        mode = self.mode if self.mode else ''
        return f'module_directory "{self.path}" "{mode}"'


class ModuleCopy(Module):
    def __init__(self, path=None, src=None, force=False):
        self._path = path
        self._src = src
        self._force = force

    @property
    def path(self):
        return self._path

    @property
    def src(self):
        return self._src

    @property
    def force(self):
        return self._force

    def get_func(self):
        return dedent('''\
          module_copy() {
            local src="$1" path="$2" force="$3"
            exists=$(test -e "$path" && echo 'y')
            if [ ! "${exists+x}" ]; then
              if should_process "copy" "$src to $path"; then
                cp -av "$src" "$path"
              fi
            elif [ "${exists+x}" ] && [ "${force+x}" ]; then
              if should_process "copy" "$src to $path"; then
                cp -afv "$src" "$path"
              fi
            fi
          }''')

    def get_cmd(self):
        force = self.force if self.force else ''
        return f'module_copy "{self.src}" "{self.path}" "{force}"'


class ModuleTouch(Module):
    def __init__(self, path=None):
        self._path = path

    @property
    def path(self):
        return self._path

    def get_func(self):
        return dedent('''\
          module_touch() {
            if should_process "touch" "$path"; then
              touch "$1"
            fi
          }''')

    def get_cmd(self):
        return f'module_touch "{self.path}"'


class ModuleLineinfile(Module):
    def __init__(self, path=None, line=None):
        self._path = path
        self._line = line

    @property
    def path(self):
        return self._path

    @property
    def line(self):
        return self._line

    def get_func(self):
        return dedent('''\
          module_lineinfile() {
            local path="$1" line="$2"
            if [ -f "$path" ]; then
              if ! grep -Fq "$line" "$path"; then
                if should_process "make backup" "$path"; then
                  cp -afv "$path"{,"-$(date "+%F.%s")"}
                fi
                if should_process "append" "line: $line, path: $path"; then
                  { echo ""; echo "$line"; } | tee -a "$path" >/dev/null
                fi
              fi
            fi
          }''')

    def get_cmd(self):
        return f'module_lineinfile "{self.path}" "{self.line}"'


class Task(ABC):
    def __init__(self, name=None, module=None, when=None):
        self._name = name
        self._module = module
        self._when = when

    @property
    def name(self) -> str:
        return self._name

    @property
    def module(self) -> Module:
        return self._module

    @property
    def when(self):
        return self._when


class TaskV1(Task):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)


class Playbook(ABC):
    def __init__(
            self, playbook_version: str = None, tasks: List[Task] = None):
        self._playbook_version = playbook_version
        self._tasks = tasks

    @property
    def playbook_version(self) -> str:
        return self._playbook_version

    @property
    def tasks(self) -> List[Task]:
        return self._tasks


class PlaybookV1(Playbook):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)


class ModuleFactory(ABC):
    def add(self, module_name: str, cls):
        raise RuntimeError()

    def create(self, module_name: str, params: dict) -> Module:
        raise RuntimeError()


class ModuleFactoryV1(ModuleFactory):
    def __init__(self):
        self._module_class = dict()

    def add(self, module_name: str, cls):
        self._module_class[module_name] = cls

    def create(self, module_name: str, params: dict) -> Module:
        cls = self._module_class[module_name]
        return cls(**params)


class TaskFactory(ABC):
    def __init__(self, module_factory: ModuleFactory):
        raise NotImplementedError()

    def create(self, **kwargs) -> Task:
        raise NotImplementedError()


class TaskFactoryV1(ABC):
    def __init__(self, module_factory: ModuleFactory):
        self._module_factory = module_factory

    def create(self, **kwargs) -> Task:
        module_name = kwargs.pop('module')
        params = kwargs.pop('params')
        task_dic = copy.deepcopy(kwargs)
        module = self._module_factory.create(module_name, params)
        task_dic['module'] = module
        return Task(**task_dic)


class PlaybookLoader(ABC):
    def load(self, f) -> Playbook:
        raise NotImplementedError()


class PlaybookLoaderV1(PlaybookLoader):
    def __init__(self, task_factory: TaskFactory):
        self._task_factory = task_factory

    def _load_playbook(self, playbook_dic):
        tasks = list()
        for task_dic in playbook_dic['tasks']:
            task = self._task_factory.create(**task_dic)
            tasks.append(task)
        return PlaybookV1(
                playbook_version=playbook_dic['playbook_version'],
                tasks=tasks)

    def load(self, f) -> Playbook:
        return self._load_playbook(json.load(f))


class TextBuilder(object):
    def __init__(self):
        self._lines = list()

    def add_text(self, line: str):
        self._lines.append(line)

    def get(self) -> str:
        return ''.join(map(lambda x: f"{x}\n", self._lines))


class Translator(ABC):
    def __init__(self, playbook: Playbook):
        self._playbook = playbook

    def translate(self) -> str:
        raise NotImplementedError()


class TranslatorV1(Translator):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def _add_shebang(self, b: TextBuilder):
        b.add_text('#!/bin/bash')

    def _add_when_functions(self, b: TextBuilder):
        b.add_text(dedent('''\
whatif=y
should_process() {
  local operation="$1" target="$2"
  if [[ "${whatif+x}" ]]; then
    echo "WhatIf: The operation '$operation' is executed on the target '$target'."
    return 1
  fi
  return 0
}
is_unix() {
  return 0
}
is_windows() {
  return 1
}
executable() {
  type "$1" >/dev/null 2>&1
}
tmux_ver_int() {
  local ver_str major minor
  ver_str=$(tmux -V | cut -d' ' -f2)
  major=$(echo "$ver_str" | cut -d. -f 1)
  minor=$(echo "$ver_str" | cut -d. -f 2 | grep -Po '\\d+')
  printf "%d%02d" "$major" "$minor"
}
tmux_version_lt_2pt1() {
  executable tmux && [[ $(tmux_ver_int) -lt 201 ]]
}
tmux_version_ge_2pt1() {
  executable tmux && [[ $(tmux_ver_int) -ge 201 ]]
}'''))

    def _add_module_functions(self, b: TextBuilder):
        module_exists = dict()
        for task in self._playbook.tasks:
            module_name = task.module.get_module_name()
            if module_name not in module_exists:
                b.add_text(task.module.get_func())
                module_exists[module_name] = True

    def _add_functions(self, b: TextBuilder):
        self._add_when_functions(b)
        self._add_module_functions(b)

    def _get_when_str(self, when: list) -> str:
        assert len(when) == 2
        ret = ''
        if when[0] == 'true':
            ret += 'true'
            if len(when[1]) != 0:
                raise RuntimeError(when)
        elif when[0] == 'is_unix':
            ret += 'is_unix'
            if len(when[1]) != 0:
                raise RuntimeError(when)
        elif when[0] == 'is_windows':
            ret += 'is_windows'
            if len(when[1]) != 0:
                raise RuntimeError(when)
        elif when[0] == 'tmux_version_lt_2pt1':
            ret += 'tmux_version_lt_2pt1'
            if len(when[1]) != 0:
                raise RuntimeError(when)
        elif when[0] == 'tmux_version_ge_2pt1':
            ret += 'tmux_version_ge_2pt1'
            if len(when[1]) != 0:
                raise RuntimeError(when)
        elif when[0] == 'and':
            when2 = list()
            for w in when[1]:
                when2.append('( ' + self._get_when_str(w) + ' )')
            ret += ' && '.join(when2)
        else:
            raise RuntimeError(when)
        return ret

    def translate(self) -> str:
        b = TextBuilder()
        self._add_shebang(b)
        self._add_functions(b)

        for task in self._playbook.tasks:
            b.add_text(f'echo "# TASK [{task.name}]"')
            cond = self._get_when_str(
                    task.when if task.when else ['true', []])
            b.add_text(dedent(f'''\
              if {cond}; then
                {task.module.get_cmd()}
              fi'''))
        return b.get()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '--source', type=argparse.FileType('r'), required=True)
    args = parser.parse_args()

    module_factory: ModuleFactory = ModuleFactoryV1()
    module_factory.add('symlink', ModuleSymlink)
    module_factory.add('directory', ModuleDirectory)
    module_factory.add('copy', ModuleCopy)
    module_factory.add('touch', ModuleTouch)
    module_factory.add('lineinfile', ModuleLineinfile)

    task_factory: TaskFactory = TaskFactoryV1(module_factory)

    loader: PlaybookLoader = PlaybookLoaderV1(task_factory)
    playbook = loader.load(args.source)

    translator: Translator = TranslatorV1(playbook=playbook)

    print(translator.translate())


if __name__ == '__main__':
    main()
