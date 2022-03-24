pipeline{
    agent { label "xxxxx"}    // 指定在哪台节点上执行构建操作，这里指定执行节点的标签
    
    options {
        timestamps()    // 日志记录时间
        buildDiscarder(logRotator(numToKeepStr: '10'))    // 只保留10个构建历史
        timeout(time: 1, unit: 'HOURS')   //流水线超时设置1h
    }

    stages {
        stage("pull code"){    // 拉取代码阶段
            steps{
                script{
                    git credentialsId: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx', url: 'https://xxx.xxxxxx.com/xxxx/xxxxxxxxxxx.git'
                }
            }
        }


        stage("Test"){    // 代码测试阶段，因各种因素影响，不能直接将公司测试代码发出来，参照即可
            steps{
                sh 'echo "build project"'
            }
        }

        stage("murphysec scan") {    // 墨菲安全CLI检测阶段
            environment {
                API_TOKEN = credentials('murphysec-token')    // {murphusec-token}是Jenkins内创建的墨菲安全访问令牌凭据，墨菲安全CLI工具默认会读取{API_TOKEN}这个变量名当作自己的{--token}参数
                }
            steps{
                sh '''
                    NUM=`murphysec scan .  --json | jq . | jq ".comps | map(select(.show_level == 1)) | length"`
                    if [ $NUM -ne 0 ];then
                        false
                    fi
                '''
            }
        }

        stage("build"){    // 代码构建阶段，因各种因素影响，不能直接将公司测试代码发出来，参照即可
            steps{
                sh 'echo "build project"'
            }
        }

        stage("publish project"){    // 代码上传阶段，因各种因素影响，不能直接将公司测试代码发出来，参照即可
            steps{
                sh 'echo "publish project"'
            }
        }
    }


    post {    // 构建后的操作
        success {    // 步骤全部执行成功后执行
            script{
                currentBuild.description = "\n 打包成功！"
                sh '''
                    DATE=`date "+%Y-%m-%d_%H:%M:%S"`
                    sh /usr/local/script/feishu.sh "项目：'$JOB_NAME'\\n结果：打包成功！已触发发布流程\\n时间：'$DATE'\\n节点：'$NODE_NAME'"
                '''
            }
        }

        failure {    // 步骤只要有一个执行失败就执行
            script{    // feishu.sh脚本是一个简单的shell脚本，存放在构建机器上，用于将构建返回的结果信息通过脚本发送至飞书群内
                currentBuild.description = "\n 打包失败！" 
                sh '''
                    DATE=`date "+%Y-%m-%d_%H:%M:%S"`
                    sh /usr/local/script/feishu.sh "项目：'$JOB_NAME'\\n结果：打包失败！\\n时间：'$DATE'\\n节点：'$NODE_NAME'\\n原因：项目中存在强烈建议修复组件！"
                '''
            }
        }
    }
}