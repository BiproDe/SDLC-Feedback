# Infrastructure as Code - Test Prompts

## TC-INF-026: Multi-Cloud IaC Strategy
**Objective**: Test Infrastructure as Code expertise and multi-cloud implementation

### Primary Prompt:
```
Create a comprehensive Infrastructure as Code strategy for deploying a 3-tier web application 
across AWS, Azure, and GCP. Include networking, security groups, load balancers, auto-scaling, 
databases, and monitoring. The infrastructure must support blue-green deployments, be 
cost-optimized, and include proper tagging and resource management. Use Terraform as the 
primary tool with cloud-specific modules.
```

### Expected Output:
- Multi-cloud Terraform architecture and modules
- Networking and security configuration
- Auto-scaling and load balancing setup
- Database and storage provisioning
- Monitoring and logging infrastructure
- Blue-green deployment support
- Cost optimization strategies
- Resource tagging and management policies

### Success Criteria:
- ✅ Comprehensive multi-cloud IaC implementation
- ✅ Proper modularization and code reusability
- ✅ Security and compliance built-in
- ✅ Cost optimization considerations

---

## TC-INF-027: Terraform Enterprise Implementation
**Objective**: Test advanced Terraform practices and enterprise features

### Primary Prompt:
```
Design a Terraform Enterprise implementation for a large organization with 20+ teams, 
multiple AWS accounts, and complex approval workflows. Include workspace management, 
policy as code (Sentinel), remote state management, CI/CD integration, and governance 
controls. The solution must support multi-environment deployments and disaster recovery.
```

### Expected Output:
- Terraform Enterprise workspace strategy
- Policy as Code (Sentinel) implementation
- Remote state management and locking
- CI/CD pipeline integration
- Multi-account and cross-account management
- Governance and approval workflows
- Disaster recovery for infrastructure code
- Team collaboration and access controls

### Success Criteria:
- ✅ Enterprise-scale Terraform governance
- ✅ Policy enforcement and compliance
- ✅ Scalable workspace management
- ✅ Robust CI/CD integration

---

## TC-INF-028: Kubernetes Infrastructure Provisioning
**Objective**: Test Kubernetes infrastructure automation and management

### Primary Prompt:
```
Create Infrastructure as Code templates for provisioning and managing a production 
Kubernetes cluster on AWS EKS with all supporting infrastructure. Include VPC design, 
subnet configuration, security groups, IAM roles, node groups, add-ons (CNI, CSI, monitoring), 
and integration with AWS services (ALB, EFS, RDS). Include cluster upgrades and scaling automation.
```

### Expected Output:
- Complete EKS cluster provisioning code
- VPC and networking infrastructure
- Security groups and IAM configuration
- Node groups and auto-scaling setup
- Add-ons and integrations (ALB Controller, EFS CSI, etc.)
- Monitoring and logging infrastructure
- Cluster upgrade and maintenance automation
- Cost optimization and resource management

### Success Criteria:
- ✅ Production-ready Kubernetes infrastructure
- ✅ Comprehensive security configuration
- ✅ Automated scaling and updates
- ✅ Integration with cloud-native services

---

## TC-INF-029: Infrastructure Testing and Validation
**Objective**: Test infrastructure testing and validation strategies

### Primary Prompt:
```
Implement a comprehensive testing strategy for Infrastructure as Code including unit tests, 
integration tests, security tests, and compliance validation. Include testing for Terraform 
modules, policy validation, cost estimation, and infrastructure drift detection. The strategy 
should support multiple environments and provide automated feedback in CI/CD pipelines.
```

### Expected Output:
- IaC testing framework and strategy
- Unit testing for Terraform modules (Terratest, etc.)
- Security and compliance testing (tfsec, Checkov)
- Infrastructure validation and drift detection
- Cost estimation and optimization testing
- Integration with CI/CD pipelines
- Multi-environment testing approach
- Automated reporting and feedback

### Success Criteria:
- ✅ Comprehensive testing coverage
- ✅ Automated validation in pipelines
- ✅ Security and compliance checking
- ✅ Cost impact analysis

---

## TC-INF-030: Azure Resource Manager (ARM) Templates
**Objective**: Test Azure-specific Infrastructure as Code implementation

### Primary Prompt:
```
Create Azure Resource Manager (ARM) templates and Bicep code for deploying a complete 
enterprise application stack including App Service, Azure SQL Database, Key Vault, 
Application Gateway, Virtual Network, and Log Analytics. Include parameter files for 
different environments, output variables, and integration with Azure DevOps pipelines.
```

### Expected Output:
- Complete ARM/Bicep template structure
- Multi-environment parameter configuration
- Resource dependencies and deployment order
- Security and network configuration
- Key Vault integration for secrets
- Monitoring and logging setup
- Azure DevOps pipeline integration
- Cost optimization and resource tagging

### Success Criteria:
- ✅ Production-ready ARM/Bicep templates
- ✅ Proper parameterization and modularity
- ✅ Security best practices implementation
- ✅ DevOps pipeline integration

---

## TC-INF-031: AWS CloudFormation Advanced Patterns
**Objective**: Test AWS CloudFormation expertise and advanced patterns

### Primary Prompt:
```
Design AWS CloudFormation templates using advanced patterns including nested stacks, 
cross-stack references, custom resources, and CloudFormation macros. Create a complete 
serverless application infrastructure with Lambda functions, API Gateway, DynamoDB, 
S3, CloudFront, and proper IAM roles. Include automated deployment and rollback capabilities.
```

### Expected Output:
- Advanced CloudFormation template architecture
- Nested stacks and modular design
- Custom resources and Lambda-backed resources
- Cross-stack references and outputs
- Serverless application infrastructure
- IAM roles and security policies
- Automated deployment strategies
- Error handling and rollback procedures

### Success Criteria:
- ✅ Advanced CloudFormation patterns usage
- ✅ Modular and reusable template design
- ✅ Comprehensive serverless infrastructure
- ✅ Robust deployment and recovery mechanisms
