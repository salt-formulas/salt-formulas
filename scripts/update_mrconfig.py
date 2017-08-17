#!/usr/bin/env python3

import configparser
import re
import github


def make_github_agent(user=None, password=None):
    """ Create github agent to auth """
    if not user:
        return github.Github()
    else:
        return github.Github(user, password)


def get_org_repos(gh, org_name):
    org = gh.get_organization(org_name)
    for repo in org.get_repos():
        yield repo.name


def gen_repo_config(org, repo):
    formula_name = re.match('^salt-formula-(.*)?', repo).group(1)
    config = {
        'formulas/%s' % (formula_name): {
            'checkout': 'git_checkout %s' % (formula_name),
            'skip': 'lazy'
        }
    }
    return config


def main():
    config = configparser.ConfigParser()
    config.read('.mrconfig')
    config_new = configparser.ConfigParser()
    config_new['DEFAULT'] = config['DEFAULT']

    gh = make_github_agent()

    repos = []
    for repo in get_org_repos(gh, "salt-formulas"):
        if not repo.startswith('salt-formula-'):
            continue
        if repo not in repos:
            repos.append(repo)
            rconf = gen_repo_config("salt-formulas", repo)
            for key, value in rconf.items():
                config_new[key] = value
        else:
            print("Repository %s present in different organization" % repo)

    with open('.mrconfig', 'w') as fh:
        config_new.write(fh)


if __name__ == '__main__':
    main()
