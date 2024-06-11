#!/bin/bash
#.tar.gz
repo-add -n -R sentorepo.db.tar.gz *.pkg.tar.zst

sudo rm sentorepo.db sentorepo.files

sudo mv sentorepo.files.tar.gz sentorepo.files

sudo mv sentorepo.db.tar.gz sentorepo.db
