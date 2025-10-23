#  EasyPay - High Availability DevOps Infrastructure  

> **Goal:** Build a fully automated, high-availability DevOps infrastructure for the **EasyPay** e-commerce payment application using **Terraform**, **Ansible**, and **Kubernetes** on **AWS**.  

---  

##  Project Overview  

EasyPay’s payment success rate had dropped due to **database connectivity timeouts** caused by frequent database downtimes.  
This project provides a **resilient, self-healing, and fully automated infrastructure** to eliminate downtime and ensure continuous availability.  

###  Key Features

- **Infrastructure as Code (IaC)** with Terraform  
- **Automated server configuration** using Ansible   
- **Highly available Kubernetes cluster** for application, MySQL, and Redis   
- **Dynamic inventory** automatically updates EC2 instances   
- **Fully re-runnable setup** — no manual changes required after destroy/recreate  
- **Integrated CI/CD** with GitHub Actions or Jenkins  

---

##  Tech Stack  

| Layer | Tool | Purpose |  
|-------|------|----------|  
| Provisioning |  **Terraform** | Creates EC2 instances, VPCs, subnets, security groups, and key pairs | 
| Configuration Management |  **Ansible** | Installs Docker, sets up Kubernetes, deploys app |
| Orchestration |  **Kubernetes** | Manages pods, services, ingress, HA DB, and cache |
| CI/CD |  **GitHub Actions / Jenkins** | Automates Terraform & Ansible validation and deployment |
| OS & IDE | 💻 **Ubuntu + WSL + VSCode** | Local development and AWS connectivity |

---

##  Directory Structure

```
easypay-infra/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── ansible/
│   ├── inventory/
│   │   ├── hosts.ini
│   │   └── hosts.yaml
│   ├── playbooks/
│   │   ├── base-setup.yaml
│   │   ├── kubernetes-setup.yaml
│   │   └── app-deployment.yaml
│   ├── roles/
│   │   ├── docker/
│   │   ├── kubernetes/
│   │   └── app/
│   └── ansible.cfg
│
├── kubernetes/
│   ├── deployments/
│   │   ├── app-deployment.yaml
│   │   ├── mysql-deployment.yaml
│   │   └── redis-deployment.yaml
│   ├── services/
│   │   ├── app-service.yaml
│   │   └── db-service.yaml
│   ├── networking/
│   │   ├── flannel.yaml
│   │   ├── network-policy.yaml
│   │   └── ingress.yaml
│   ├── rbac/
│   │   └── pod-manager-role.yaml
│   └── storage/
│       └── pvc.yaml
│
├── scripts/
│   ├── init-cluster.sh
│   ├── join-workers.sh
│   ├── backup-etcd.sh
│   └── health-check.sh
│
├── jenkins/
│   └── Jenkinsfile
│
└── README.md
```

---

##  Infrastructure Workflow

###  **Terraform — Provision Infrastructure**
- Creates **VPC**, **subnets**, **security groups**, and **EC2 instances**
- Generates SSH keys automatically
- Exports public/private IPs for Ansible inventory

**Run:**
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

---

###  **Ansible — Configure & Deploy**
- Installs **Docker** and **Kubernetes**
- Initializes **Kubernetes master**
- Joins **worker nodes**
- Deploys **MySQL**, **Redis**, and **EasyPay application**

**Run:**
```bash
cd ansible
ansible-playbook playbooks/base-setup.yaml
ansible-playbook playbooks/kubernetes-setup.yaml
ansible-playbook playbooks/app-deployment.yaml
```

---

###  **Kubernetes — Manage & Scale**
- Uses **Deployments**, **Services**, **Ingress**, and **PVC**
- Ensures **auto-healing** and **HA architecture**
- Allows **zero-downtime deployments**

**Check cluster health:**
```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc
```

---

###  **Jenkins / GitHub Actions — CI/CD**
- Automatically validates Terraform and Ansible syntax
- Triggers infrastructure deployment
- Deploys new app versions to Kubernetes

---

##  High Availability Design

| Component | HA Strategy |
|------------|-------------|
| EC2 Instances | Multi-AZ Auto Scaling |
| MySQL | StatefulSet + Persistent Volume |
| Redis | Master-Replica setup |
| Kubernetes Control Plane | Self-healing via kubeadm |
| Application Pods | Replicated deployments with rolling updates |

---

## Scripts Included

| Script | Purpose |
|---------|----------|
| `init-cluster.sh` | Initialize Kubernetes master node |
| `join-workers.sh` | Join worker nodes automatically |
| `backup-etcd.sh` | Take ETCD database backup |
| `health-check.sh` | Verify Kubernetes cluster and pod health |

---

##  Dynamic Inventory (Ansible)
- Automatically updates hosts when Terraform recreates EC2 instances  
- Uses AWS dynamic inventory plugin (`aws_ec2`)  
- No manual IP updates required

---

## 🧠 Future Enhancements
- Add **Prometheus + Grafana** monitoring
- Add **ELK / EFK logging**
- Integrate **Vault** for secret management
- Extend **blue-green deployment** support
- Include **Helm charts** for app packaging

---

## 👨‍💻 Author

**Bhagyavan B**  
DevOps Engineer | Cloud & Automation Enthusiast  
📧 [bhagyavan8050@gmail.com](mailto:bhagyavan8050@gmail.com)  
🌐 [GitHub: Bhagyavan8050](https://github.com/Bhagyavan8050)

---

## 🏁 Summary

The **EasyPay High-Availability Infrastructure** project demonstrates an end-to-end automated DevOps pipeline using modern tools — achieving **zero manual intervention**, **auto-healing**, and **100% uptime** deployment for a critical payment application.

---
