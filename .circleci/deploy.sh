#!/usr/bin/env bash

# エラー時、実行を止める
set -e

DEPLOY_DIR=deploy

# gitの諸々の設定
git config --global push.default simple
git config --global user.email $(git --no-pager show -s --format='%ae' HEAD)
git config --global user.name $CIRCLE_USERNAME

# gh-pagesブランチをdeployディレクトリにクローン
git clone -q --branch=master $CIRCLE_REPOSITORY_URL $DEPLOY_DIR

# rsyncでhugoで生成したHTMLをコピー
cd $DEPLOY_DIR
rsync -arv --delete ../public/* .

git add -f .
git commit -m "Deploy #$CIRCLE_BUILD_NUM from CircleCI [ci skip]" || true
git push -f
