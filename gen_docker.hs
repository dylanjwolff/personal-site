#!/usr/bin/env stack
-- stack --resolver lts-15.3 script


{-# LANGUAGE OverloadedStrings #-}

import Turtle
import Data.Text

main = output "Dockerfile.x86_64" $ get_x86_64 "template.Dockerfile"

get_arm64 f = subst_nginx "arm64v8/nginx" $ subst_qarch "aarch64" $ input f
get_x86_64 f = subst_nginx "nginx" $ subst_qarch "fake-x86_64" $ input f
subst_nginx b s = subst "{NGINX}" b s
subst_qarch b s = subst "{QEMU-ARCH}" b s
subst a b s = sed (a *> return b) s
