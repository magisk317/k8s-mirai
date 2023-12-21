Mirai dockerize
----
本项目分两个部分，一个是执行在容器的Mirai，一个是安装到k8s集群的mirai helm chart

## (WIP) 容器Mirai
仅安装了数个本项目需要的插件的容器化mirai，如果需要定制插件，需要clone本项目自行添加
(备注，有可能容器Mirai不会包含任何插件)

默认包含插件
- fix-protocol-version-1.9.10.mirai2
- mirai-api-http-2.9.1.mirai2
- mcl-addon-2.1.1

## (WIP) Helm Chart
默认会部署一个`unidbg-fetch-sign`和一个`miria`实例，相关参数均需要下载`values.yml`来自己override，比如mirai的容器、签名服务用哪个，自动登录的qq帐号之类的。如果你基于上面的容器定制了自己需要的插件，可以在这里将image替换掉。还会挂载一个volume来存储/mirai/bots下的文件，以便集群重启也能够恢复登录状态。

### 实现原理
1. `values.yml`配置出需要的插件，或者本地通过二进制变量的形式将插件在初始化集群的时候传入，这些配置写入一个`ConfigMap`
2. 创建一个可以持久化的`volume`，用来存储插件和相关的库还有相关缓存。
3. 每次启动时通过`init container`检查`ConfigMap`中指定插件的安装或从二进制变量中读取相关插件。如果需要新增插件，走`helm upgrade`将新插件写入`ConfigMap`。
4. 每次启动时通过`init container`进行`values.yml`中的相关配置，例如：配置`sign`服务的endpoint，写入`mirai-api`的配置，写入`AutoLogin.yml`的配置等。

### 替换签名服务的备注
本项目的容器Mirai默认用`fix-protocol v1.9.10`，你如果使用非本helm提供的签名服务，则需要提供其所需的`KFCFactory.json`来进行签名服务的访问。如果你不想用`fix-protocol v1.9.10`，你可以在基础容器中将其替换掉，并在容器中，或者是进行`helm install`之后配置好需要的配置。
