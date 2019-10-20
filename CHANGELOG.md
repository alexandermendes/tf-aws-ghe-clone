# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [1.2.1](https://github.com/alexandermendes/tf-aws-ghe-clone/compare/v1.2.0...v1.2.1) (2019-10-20)


### Bug Fixes

* enable versioning on source bucket ([6277ce1](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/6277ce1f6febb2616a3c511bc2e7be4483a90dea))

## [1.2.0](https://github.com/alexandermendes/tf-aws-ghe-clone/compare/v1.1.1...v1.2.0) (2019-10-20)


### Features

* account for private github repos ([41da8de](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/41da8de13ba9b058f8f62b54fb1abc1bbe40fe17))
* add template for create webhooks Lambda ([833054e](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/833054e787560c0568b52b49b19b8fcff1b05106))
* make scheduled lambda more flexible ([a0047c6](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/a0047c65e1bd4ee3f359798cf1e487a3b1d0f13d))
* update create webhooks function ([b7d5588](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/b7d55887e4e432e8dee3eaf817d357cb85c54053))


### Bug Fixes

* add direct webhook URL to output ([8087c91](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/8087c91072bd44a031dcfc20a4e7d52034088965))
* create webhook function ([feb1579](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/feb1579cab47458f3231b8015149cee4b2dc3647))
* github clone URL ([3c74dc4](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/3c74dc40b0ea459a1e6b81d893628638cd03354f))
* object key for cloned repos ([5a232b9](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/5a232b9922b322db86263e183cd6b884762391dd))
* remove trailing semi-colon ([ff5507e](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/ff5507e155d44bcd6fe699d7032075babb57896a))
* update create webhooks request ([15a3f37](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/15a3f37e35dfa5149603773b63318750f7839e73))
* update lambda dir ([f9017d9](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/f9017d9eba39acc65b90425d9c26b4d7a97b82a9))

### [1.1.1](https://github.com/alexandermendes/tf-aws-ghe-clone/compare/v1.1.0...v1.1.1) (2019-10-17)

## 1.1.0 (2019-10-17)


### Features

* add codepipeline sample ([ee9866d](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/ee9866db30feee2a09ce7c056ffb34348b75760f))
* add git lambda layer ([8431c3a](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/8431c3aceb5e529324699f05861c952a7a7fb2f8))
* add initial setup ([217d6fb](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/217d6fb15ccb5fa45b0ac326bf53b85cc61084fd))
* add namespaces ([b6b962f](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/b6b962f6731d8012cdbbb3ed2d9f30386deffe0a))
* add webhook secret ([af3aaa5](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/af3aaa59c708f16c07a256c44aa98814fca40ef2))
* add webhook_url to output ([e0c6b00](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/e0c6b0003a76aee0bc0e96bd3e0743cdbf9cc93e))
* output ID and ARN of the S3 bucket ([fc3705f](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/fc3705f232eaeb4637060e8845473953873f9355))
* validate github webhook with secret ([c847cee](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/c847cee0bea34a41dbf03176e54ef1d69477f00b))


### Bug Fixes

* github signature validation and cloning ([b460e5a](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/b460e5af31ac586d551c81261df5d375858766bb))
* iam policy assume role id ([1b9726b](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/1b9726bfab88a501ad6897fdfe8bfee276ec0122))
* lambda_api env vars ([b7185ed](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/b7185edf682c305149caa2b54331f8ba87ed2a57))
* local.namespace > var.namespace ([04736b1](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/04736b1ef9e473fdd9fb3775ea539c2e80b95b28))
* return status code with mock response ([a4da4f9](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/a4da4f96dffc86d50d0dab4fc25b6b5a25fb7b41))
* s3 source bucket id ([162c3a8](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/162c3a878dc9203e1387bc01fc5b876631db53f0))
* switch back to node runtime ([ce56bb3](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/ce56bb382f5af354b8f899fd9aaa08739bc7c3fb))
* try to fix kms key ([8fbf7c3](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/8fbf7c3d99f339aed4e1183b006b6fb3e5e50d9c))
* update codepipeline ([c61156c](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/c61156c705aa0cbb8642edb19ae9c5db41ad0db9))
* update file ext ([ddfe4de](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/ddfe4ded5b49244bc881301c69e45c9b95b3cb81))
* update lambda runtime ([1bbf75e](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/1bbf75e09a4b06c6bf759b37af41004f31b1391f))
* update tf-aws-lambda-api ([1fc841b](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/1fc841b87e0786b0d53203b013533cb52baa0ec9))
* update tf-aws-lambda-api ([41d6fec](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/41d6fec37a00e150b81ff7afe77c2bd2339287cb))
* update tf-aws-lambda-api ([9972e5c](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/9972e5c77fa27e551998d8674efca5124f5ffe79))
* use of local var ([643eff1](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/643eff139fb627e5962d1ea65a1e61c6c2d50fd7))
* user of join ([1fb2459](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/1fb24591484821c8fe08f5619f61dc7280bdb55b))
* webhook_url output ([300a4d6](https://github.com/alexandermendes/tf-aws-ghe-clone/commit/300a4d64c3b9eea337966ed03bc10a94415e252d))
