using System;

namespace csApi
{
    using System.Collections.Generic;
    using k8s;
    using k8s.Models;

    class Program
    {
        static void Main(string[] args)
        {
            var config = KubernetesClientConfiguration.BuildDefaultConfig();
            IKubernetes client = new Kubernetes(config);
            Console.WriteLine("Starting Request!");

            var list = client.ListNamespacedPod("default");
            foreach (var item in list.Items)
            {
                Console.WriteLine(item.Metadata.Name);
            }
            
            if (list.Items.Count == 0)
            {
                Console.WriteLine("Empty!");
            }

            try
            {
                CreateDeployment(client);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Deployment may exist, updating: {ex.Message}");
                UpdateDeployment(client);
            }
        }

        static void CreateDeployment(IKubernetes client)
        {
            var deployment = new V1Deployment();
            deployment.Metadata = new V1ObjectMeta();
            deployment.Metadata.Name = "my-nginx";
            deployment.Metadata.Labels = new Dictionary<string, string>();
            deployment.Metadata.Labels.Add("app", "nginx");
            deployment.Spec = new V1DeploymentSpec();
            deployment.Spec.Replicas = 1;
            deployment.Spec.Selector = new V1LabelSelector();
            deployment.Spec.Selector.MatchLabels = new Dictionary<string, string>();
            deployment.Spec.Selector.MatchLabels.Add("app", "nginx");
            deployment.Spec.Template = new V1PodTemplateSpec();
            deployment.Spec.Template.Metadata = new V1ObjectMeta();
            deployment.Spec.Template.Metadata.Labels = new Dictionary<string, string>();
            deployment.Spec.Template.Metadata.Labels.Add("app", "nginx");
            deployment.Spec.Template.Spec = new V1PodSpec();
            deployment.Spec.Template.Spec.Containers = new List<V1Container>();
            deployment.Spec.Template.Spec.Containers.Add(new V1Container());
            deployment.Spec.Template.Spec.Containers[0].Name = "nginx";
            deployment.Spec.Template.Spec.Containers[0].Image = "nginx:1.7.9";
            deployment.Spec.Template.Spec.Containers[0].Ports = new List<V1ContainerPort>();
            deployment.Spec.Template.Spec.Containers[0].Ports.Add(new V1ContainerPort());
            deployment.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort = 80;

            var result = client.CreateNamespacedDeployment(deployment, "default");
            Console.WriteLine(result.Metadata.Name);
            Console.WriteLine(result.ToString());
        }

        private static void UpdateDeployment(IKubernetes client)
        {
            var patch = new V1Patch(
                @"{""spec"":{""template"":{""spec"":{""containers"":[{""name"":""nginx"",""image"":""nginx:1.8""}]}}}}",
                V1Patch.PatchType.MergePatch
            );
            V1Deployment deployment = client.PatchNamespacedDeployment(patch, "my-nginx", "default");
            Console.WriteLine($"Deployment updated: {deployment.Metadata.Name}");
        }
    }
}