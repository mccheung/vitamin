$namespaced_redis = Redis::Namespace.new(:vitamin, :redis => Redis.new)
