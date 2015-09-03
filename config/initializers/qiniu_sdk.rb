$qiniu_bucket = Figaro.env.qiniu_bucket
$qiniu_domain = Figaro.env.qiniu_domain

Qiniu.establish_connection! :access_key => Figaro.env.qiniu_access_key,
                            :secret_key => Figaro.env.qiniu_secret_key
