#!/usr/bin/env python3
from jinja2 import Environment, FileSystemLoader
from abc import ABC
from textwrap import dedent
from typing import List
import argparse
import copy
import json
import re
import sys


class Module(ABC):
    def get_module_name(self) -> str:
        return re.sub(r'^Module', '', self.__class__.__name__)

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

    def get_cmd(self) -> str:
        return dedent(f"module_symlink '{self.src}' '{self.path}'")


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

    def get_cmd(self) -> str:
        mode = self.mode if self.mode else ''
        return f"module_directory '{self.path}' '{mode}'"


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

    def get_cmd(self):
        force = self.force if self.force else ''
        return f"module_copy '{self.src}' '{self.path}' '{force}'"


class ModuleTouch(Module):
    def __init__(self, path=None):
        self._path = path

    @property
    def path(self):
        return self._path

    def get_cmd(self):
        return f"module_touch '{self.path}'"


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

    def get_cmd(self):
        return f"module_lineinfile '{self.path}' '{self.line}'"


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
        env = Environment(loader=FileSystemLoader('templates'))
        template = env.get_template("installer.sh.j2")

        tasks = list()
        for task in self._playbook.tasks:
            task_dic = dict()
            task_dic['name'] = task.name
            task_dic['cond'] = self._get_when_str(
                    task.when if task.when else ['true', []])
            task_dic['command'] = task.module.get_cmd()
            tasks.append(task_dic)

        return template.render(tasks=tasks)


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
