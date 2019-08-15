local helpers = import 'helpers.jsonnet';

local Helmrelease(config, group) = helpers.helmrelease(config, group) {
  spec+: {
    chart: {
      repository: 'https://kubernetes-charts.storage.googleapis.com/',
      name: 'cluster-autoscaler',
      version: '0.14.2',
    },
    values+: {
      rbac: {
        create: true,
      },
      autoDiscovery: {
        clusterName: config.cluster.eks.name,
      },
      awsRegion: config.cluster.eks.region,
      groupMonitor: 'enabled',
      sslCertHostPath: '/etc/ssl/certs/ca-bundle.crt',
      extraArgs: {
        v: 4,
        stderrthreshold: 'info',
        logtostderr: true,
        'skip-nodes-with-local-storage': false,
      },
    },
  },
};

function(config) {
  local group = config.groups.autoscaler { name: 'autoscaler' },
  Helmrelease: if group.helmrelease.create then Helmrelease(config, group),
  Namespace: if group.namespace.create then helpers.namespace(config, group),
}