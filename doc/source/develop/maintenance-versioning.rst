`Home <index.html>`_ SaltStack-Formulas Development Documentation

Formula Versioning
==================

Current versioning system is date based same as `Saltstack versioning`_ using
format ``YYYY-MM-R`` (year-month-revision) where revision is minor release
that increments of 1 starting at 0.

Making release
--------------

Releasing is currently not automatic and is up to maintainer of individual
formula.

To automate the tasks needed to make a new release, there are unified targets
in ``Makefile`` that should be present in each formula repository.

See ``make help`` for more information, there are ``release-major`` and
``release-minor`` targets. First one will create new major release by current
date. Second will raise revision of current major release.

Example use and output:

::

  $ make release-minor
  Current version is 2017.2, new version is 2017.2.1
  echo "2017.2.1" > VERSION
  sed -i 's,version: .*,version: "2017.2.1",g' metadata.yml
  [ ! -f debian/changelog ] || dch -v 2017.2.1 -m --force-distribution -D `dpkg-parsechangelog -S Distribution` "New version"
  make genchangelog-2017.2.1
  make[1]: Entering directory '/home/filip/src/salt-formulas/formulas/letsencrypt'
  (echo "=========\nChangelog\n=========\n"; \
  (echo 2017.2.1;git tag) | sort -r | grep -E '^[0-9\.]+' | while read i; do \
      cur=$i; \
      test $i = 2017.2.1 && i=HEAD; \
      prev=`(echo 2017.2.1;git tag)|sort|grep -E '^[0-9\.]+'|grep -B1 "$cur\$"|head -1`; \
      echo "Version $cur\n=============================\n"; \
      git log --pretty=short --invert-grep --grep="Merge pull request" --decorate $prev..$i; \
      echo; \
  done) > CHANGELOG.rst
  make[1]: Leaving directory '/home/filip/src/salt-formulas/formulas/letsencrypt'
  (git add -u; git commit -m "Version 2017.2.1")
  [master 4859e22] Version 2017.2.1
   4 files changed, 81 insertions(+), 13 deletions(-)
   rewrite CHANGELOG.rst (98%)
  git tag -s -m 2017.2.1 2017.2.1

  $ git show
    ...
  $ git push origin master
  $ git push origin --tags

Read more
---------

.. _`Saltstack versioning`: https://docs.saltstack.com/en/latest/topics/releases/version_numbers.html
