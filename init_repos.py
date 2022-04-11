#!/usr/bin/python

from typing import List
import os
import shutil
import sys
import subprocess

DIR_FOR_REPOS: str = '/home/hypermaq/repos'
# REPOS_LIST: list of all repo names that need to be cloned from github.com/Panthyr
REPOS_LIST: List[str] = [
    'shell_scripts', 'panthyr_logging', 'panthyr_db', 'panthyr_credentials', 'panthyr_core',
    'panthyr_suncalc', 'panthyr_gpio', 'panthyr_ftp', 'panthyr_flir_ptu_d48e', 'panthyr_gnss',
    'panthyr_ip_check'
]


def main():

    prepare_dir()

    failed_clone: List = []  # List of failed clones
    failed_install: List = []  # List of failed package installs
    for repo in REPOS_LIST:
        failed_clone = clone_repo(repo, failed_clone)

    for repo in REPOS_LIST:
        if repo in failed_clone:
            continue
        install_pkg(repo, failed_install)

    if any([failed_clone, failed_install]):
        print('FINISHED WITH ERRORS:')
        if failed_clone:
            print(f'FAILED REPOS: {", ".join(failed_clone)}')
        if failed_install:
            print(f'CLONED OK BUT FAILED INSTALLS: {", ".join(failed_install)}')
    else:
        print('FINISHED.')


def install_pkg(repo: str, failed_install: List):
    print(f'-> INSTALLING PACKAGE {repo} (MASTER branch!)...', end='', flush=False)
    rtn = subprocess.run(['pip', 'install', '-e', _target_dir(repo)],
                         capture_output=True,
                         text=True)
    if rtn.returncode == 0:
        print('OK.')
    else:
        print('\nIssue during installation:')
        print(f'{rtn.stderr}')
        failed_install.append(f'{repo}')
    return (failed_install)


def clone_repo(repo: str, failed: List):
    full_identifier: str = f'git@github.com:Panthyr/{repo}.git'
    target_dir: str = _target_dir(repo)
    print(f'-> CLONING {full_identifier}...', end='', flush=False)
    rtn = subprocess.run(['git', 'clone', full_identifier, target_dir],
                         capture_output=True,
                         text=True)
    if rtn.returncode == 0:
        print('OK.')
    else:
        print('\nIssue during clone:')
        print(f'{rtn.stderr}')
        failed.append(repo)
    return (failed)


def _target_dir(repo: str):
    return (os.path.join(DIR_FOR_REPOS, repo))


def prepare_dir():
    if os.path.isdir(DIR_FOR_REPOS):
        cleanup: str = input(
            f'Directory {DIR_FOR_REPOS} exists. Delete recursively and start over?\n'
            'Enter "y" to delete')
        if cleanup == 'y':
            print(f'Performing recursive delete of {DIR_FOR_REPOS}...')
            try:
                shutil.rmtree(DIR_FOR_REPOS)
                print('DONE')
            except PermissionError:
                print(
                    'PermissionError during recursive delete. Please clear the directory manually.'
                    f'\n You might have to use "sudo rm -r {DIR_FOR_REPOS}" ')
        else:
            print('Leaving directory as-is.')
    try:
        os.makedirs(DIR_FOR_REPOS, exist_ok=True)
    except Exception as e:
        print(f'Error during creation of directory {DIR_FOR_REPOS}: {e}.\nNow exiting.')
        sys.exit()


if __name__ == '__main__':
    main()
