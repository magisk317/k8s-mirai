Mirai dockerize
----
本项目分两个部分，一个是执行在容器的Mirai，一个是安装到k8s集群的mirai helm chart

## 容器化的Mirai
仅安装了数个本项目需要的插件的容器化mirai，如果需要定制插件，需要clone本项目自行添加。

默认包含插件
- fix-protocol-version-1.9.10.mirai2
- mirai-api-http-2.9.1.mirai2
- mcl-addon-2.1.1

#### 如何构建镜像
```bash
cd mirai

# 安装你需要的插件
cp ... ./plugins

docker build . -t 你的tag
docker push 你的tag
```
#### 如何使用镜像？
下列相关可挂载文件夹及其用途：
- `/mirai/config` 配置
- `/mirai/bots` 登录缓存
- `/mirai/logs` 日志

```bash
docker run -it -v ...你需要挂载的文件夹... 你的tag
```

## Helm Chart
### 部署步骤
```bash
cd helm

# 需要按照values.yaml中的内容自行修改
vim ./values.yaml

# 安装mirai到你的k8s集群
helm install mirai ./
```

#### 一些说明
- 默认会部署一个`mirai-sign`和一个`mirai`实例，相关参数均需要下载`values.yml`来自己override，比如mirai的容器、签名服务用哪个，自动登录的qq帐号之类的。
- 如果你基于上面的容器定制了自己需要的插件，需要在这里将image替换掉
- 还会挂载两个volume来存储文件，一个存`/mirai/bots`，一个存`/mirai/logs`，`/mirai/bots`是bots的登录状态，这两个存储都能在设置中关掉。
- 默认的签名服务是`unidbg-fetch-qsign`，默认使用的容器见[这个项目](https://github.com/Deliay/unidbg-fetch-qsign-container)。如果你需要其他的签名服务，可以直接替换镜像，然后修改为对应端口即可。
- 配置中的`configurations`节点可以在`maria`的容器中生成对应的配置文件，如果你自定义了插件，可以用这个来将配置放入容器中。注意，如果你自定义了容器，且容器已经包含配置了，这里的配置会覆盖已经存在的配置。

### 替换签名服务的备注
本项目的容器Mirai默认用`fix-protocol v1.9.10`，你如果使用非本helm提供的签名服务，则需要提供其所需的`KFCFactory.json`来进行签名服务的访问。如果你不想用`fix-protocol v1.9.10`，你可以在基础容器中将其替换掉，并在容器中，或者是进行`helm install`之后配置好需要的配置。

### 图形验证码...
之前笔者比较偷懒都是在本地机器上登陆好之后，再将`bots`文件夹打包扔到服务器覆盖，将整个方案扔到k8s集群里显然不能继续用这么土的方法了。但目前能想到比较好操作的方法也只是在集群内搞个临时http代理，然后再到本机验证了，过于麻烦，最终还是选择了把bots的PVC挂在出来，然后手动覆盖了。

### 一些小技巧
这些技巧会在执行完helm install之后打印到控制台，一些变量如安装的`namespace`会有相应替换，请以`helm install`之后显示的结果为准

#### 直接转发容器的端口到本地
本地调试api的时候很好用
```
export POD_NAME=$(kubectl get pods --namespace mirai -l "app.kubernetes.io/name=mirai,app.kubernetes.io/instance=mirai" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace mirai $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace mirai port-forward $POD_NAME 8080:$CONTAINER_PORT
```

#### attch到mcl的容器
突发情况执行一些命令很好用
```
kubectl attach -n mirai -it deployment/mirai
```


