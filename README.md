## Kaniko示例

这是一个使用 Kaniko 在 Kubernetes 集群中构建镜像的示例项目。

Kaniko 是 Google 发布的在 Kubernetes 集群中构建容器镜像的工具，项目的[github](https://github.com/GoogleContainerTools/kaniko)中介绍的特点是：

```
kaniko is tool to build container images from a Dockerfile,inside a container or Kubernetes cluster.
```

### 工作原理

Kaniko 的工作原理是：按照顺序执行每一条命令，每条命令执行完毕后为文件系统做快照（snapshot）。并与上一个快照进行对比，如果发现任何不一致，便会创建一个新的层级，并将任何修改都写入镜像的元数据中。

当 Dockerfile 中每条命令都执行完毕后，Kaniko 将生成的镜像 push 到指定的 registry。

### 详细说明

Kaniko 解决了在 Kubernetes 集群构建镜像的问题，但是构建的项目、目标 registry 的认证、Dockerfile 的分发，还是需要我们自己考虑。

这个示例本身是一个非常非常简单的 gin 框架的 web 示例。实现 ping-pong 请求应答。

在 [deploy目录下](https://github.com/cuijxin/gin-demo/blob/master/deploy/clone-job.yaml)有拉取项目代码的 job 的 YAML 文件，可以看到在这里我创建了一个 pvc 对象，然后把这个 pvc 对象挂载到 job 对象上，拉取的代码就保存在这个 pvc 对象里。

接下来要解决的目标是 registry 的认证问题，官方文档中的样例是通过一个  `kaniko-secret.json` 并把内容赋值给 `GOOGLE_APPLICATIOn_CREDENTIALS` 这个环境变量，我们在这里直接使用 docker config 的方法。

```
# cd ~/.docker/
kubectl create configmap docker-config --from-file=config.json
configmap/docker-config created
```

然后就是使用 Kaniko 构建镜像的定义文件：[pod-kaniko.yaml](https://github.com/cuijxin/gin-demo/blob/master/pod-kaniko.yaml)

可以看到这里我把保存有项目代码的 pvc 对象还有 docker-config 的 configmap 都挂载到了这个 Pod 对应的目录下。

然后需要说明的是 args 中的几个参数，其中：

“--dockerfile” 是镜像项目的 Dockerfile 文件的路径。

“--context” 是镜像项目的路径。

“--destination” 是目标 registry 的路径和 tag。

### 参考文档

[Kaniko：无需特权在 Kubernetes 中构建镜像](https://blog.ihypo.net/15487483292659.html)