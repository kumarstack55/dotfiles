#!/usr/bin/env python3
from abc import ABC
from jinja2 import Environment, FileSystemLoader
from textwrap import dedent
from typing import List
import argparse
import copy
import jinja2
import json
import re


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


class ModuleGetUrl(Module):
    def __init__(self, url=None, path=None):
        self._url = url
        self._path = path

    def get_cmd(self):
        return f"module_get_url '{self._url}' '{self._path}'"


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


class ModuleFactoryInitializer(object):
    def initialize(self) -> ModuleFactory:
        f: ModuleFactory = ModuleFactoryV1()
        f.add('symlink', ModuleSymlink)
        f.add('directory', ModuleDirectory)
        f.add('copy', ModuleCopy)
        f.add('touch', ModuleTouch)
        f.add('lineinfile', ModuleLineinfile)
        f.add('get_url', ModuleGetUrl)
        return f


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


class WhenExpr(ABC):
    def __init__(self, when_expr_factory):
        self._when_expr_factory = when_expr_factory

    def get(self, args: list) -> str:
        raise NotImplementedError()


class WhenExprTrue(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'true'


class WhenExprIsMingw(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'is_mingw'


class WhenExprIsWindows(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'is_windows'


class WhenExprIsUnix(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'is_unix'


class WhenExprTmuxVersionLessThan2pt1(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'tmux_version_lt_2pt1'


class WhenExprTmuxVersionGreaterOrEqual2pt1(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        return 'tmux_version_ge_2pt1'


class WhenExprPathExists(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 1:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        path = args[0]
        return f'test_path_exists "{path}"'


class WhenExprNot(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) != 2:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        child_name, child_args = args
        when_expr = self._when_expr_factory.get(child_name)
        return '! ' + when_expr.get(child_args)


class WhenExprAnd(WhenExpr):
    def get(self, args: list) -> str:
        if len(args) == 0:
            raise RuntimeError(f"name: {self.__class__.__name__}, args:{args}")
        item_str_list = list()
        for item in args:
            child_name, child_args = item
            when_expr = self._when_expr_factory.get(child_name)
            item_str_list.append('( ' + when_expr.get(child_args) + ' )')
        return ' && '.join(item_str_list)


class WhenExprFactory(object):
    def __init__(self):
        self._name_cls = dict()

    def add(self, name: str, cls):
        self._name_cls[name] = cls

    def get(self, name: str) -> WhenExpr:
        cls = self._name_cls[name]
        return cls(self)


class WhenExprFactoryInitializer(object):
    def initialize(self) -> WhenExprFactory:
        f = WhenExprFactory()
        f.add('true', WhenExprTrue)
        f.add('is_mingw', WhenExprIsMingw)
        f.add('is_windows', WhenExprIsWindows)
        f.add('is_unix', WhenExprIsUnix)
        f.add('tmux_version_lt_2pt1', WhenExprTmuxVersionLessThan2pt1)
        f.add('tmux_version_ge_2pt1', WhenExprTmuxVersionGreaterOrEqual2pt1)
        f.add('path_exists', WhenExprPathExists)
        f.add('not', WhenExprNot)
        f.add('and', WhenExprAnd)
        return f


class Translator(ABC):
    def __init__(self, playbook: Playbook, when_expr_factory: WhenExprFactory):
        self._playbook = playbook
        self._when_expr_factory = when_expr_factory

    def translate(self) -> str:
        raise NotImplementedError()


def load_func(name):
    source = name
    return source


class TranslatorV1(Translator):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self._env = None

    def _get_when_str(self, when: list) -> str:
        assert len(when) == 2
        name, args = when
        when_expr = self._when_expr_factory.get(name)
        return when_expr.get(args)

    def _get_value_render_env(self):
        if self._env is None:
            env = jinja2.Environment(loader=jinja2.FunctionLoader(load_func))
            self._env = env
        else:
            env = self._env
        return env

    def _render_dict_value(self, dic):
        rendered = dict()

        for k in dic.keys():
            dic_or_value = dic[k]
            if isinstance(dic_or_value, dict):
                rendered[k] = self._render_dict_value(dic_or_value)
            elif isinstance(dic_or_value, str):
                env = self._get_value_render_env()
                template = env.get_template(dic_or_value)
                rendered[k] = template.render(home='$HOME')
            else:
                rendered[k] = dic_or_value

        return rendered

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

            rendered_task_dic = self._render_dict_value(task_dic)

            tasks.append(rendered_task_dic)

        return template.render(tasks=tasks)


def main():
    # Parse arguments.
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '--source', type=argparse.FileType('r'), required=True)
    args = parser.parse_args()

    # Load the playbook.
    module_factory = ModuleFactoryInitializer().initialize()
    task_factory: TaskFactory = TaskFactoryV1(module_factory)
    loader: PlaybookLoader = PlaybookLoaderV1(task_factory)
    playbook = loader.load(args.source)

    # Translate the playbook and print.
    when_expr_factory = WhenExprFactoryInitializer().initialize()
    translator: Translator = TranslatorV1(
            playbook=playbook, when_expr_factory=when_expr_factory)
    print(translator.translate())


if __name__ == '__main__':
    main()
