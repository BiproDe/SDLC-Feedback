# DevOps Pipeline - Test Prompts

## TC-INF-021: CI/CD Pipeline Design
**Objective**: Test DevOps pipeline architecture and automation capabilities

### Primary Prompt:
```
Design a comprehensive CI/CD pipeline for a microservices application with 15 services 
deployed on Kubernetes. The pipeline needs to support multiple environments (dev, staging, 
prod), automated testing (unit, integration, security, performance), blue-green deployments, 
and rollback capabilities. Include infrastructure provisioning, secrets management, and 
compliance reporting for SOX requirements.
```

### Expected Output:
- CI/CD pipeline architecture and workflow
- Multi-environment deployment strategy
- Automated testing integration (unit, integration, security, performance)
- Blue-green deployment implementation
- Rollback and recovery procedures
- Infrastructure as code integration
- Secrets and configuration management
- Compliance and audit trail reporting

### Success Criteria:
- ✅ Comprehensive pipeline covering all stages
- ✅ Automated testing and quality gates
- ✅ Deployment automation with rollback capability
- ✅ Security and compliance integration

---

## TC-INF-022: GitOps Implementation
**Objective**: Test GitOps principles and implementation strategies

### Primary Prompt:
```
Implement a GitOps-based deployment strategy for a multi-cluster Kubernetes environment 
spanning 3 regions. The solution needs to manage application deployments, infrastructure 
configuration, and security policies through Git repositories. Include automated 
synchronization, drift detection, policy enforcement, and disaster recovery across clusters.
```

### Expected Output:
- GitOps architecture and repository structure
- Multi-cluster management strategy
- Automated synchronization mechanisms
- Configuration drift detection and remediation
- Policy-as-code implementation
- Security and access control
- Disaster recovery procedures
- Monitoring and alerting for GitOps operations

### Success Criteria:
- ✅ Git-centric deployment workflow
- ✅ Multi-cluster synchronization
- ✅ Automated drift detection and correction
- ✅ Policy enforcement and compliance

---

## TC-INF-023: Container Orchestration Strategy
**Objective**: Test container orchestration and management expertise

### Primary Prompt:
```
Design a container orchestration strategy for migrating 50+ legacy applications to containers. 
The applications have different resource requirements, dependencies, and scaling patterns. 
Include containerization approach, Kubernetes cluster design, service mesh implementation, 
storage solutions, and operational procedures for a 24/7 production environment.
```

### Expected Output:
- Containerization strategy and standards
- Kubernetes cluster architecture
- Service mesh implementation (Istio/Linkerd)
- Storage and persistent volume management
- Auto-scaling and resource management
- Networking and ingress configuration
- Operational procedures and runbooks
- Migration roadmap and timeline

### Success Criteria:
- ✅ Scalable container orchestration design
- ✅ Appropriate service mesh integration
- ✅ Robust storage and networking solutions
- ✅ Comprehensive operational procedures

---

## TC-INF-024: DevSecOps Integration
**Objective**: Test security integration in DevOps pipelines

### Primary Prompt:
```
Integrate comprehensive security practices into a DevOps pipeline for a fintech application. 
Include static application security testing (SAST), dynamic application security testing 
(DAST), container image scanning, infrastructure security scanning, secret management, 
and compliance automation. The pipeline must meet PCI DSS and SOX compliance requirements.
```

### Expected Output:
- DevSecOps pipeline architecture
- Security testing integration (SAST, DAST, IAST)
- Container and infrastructure security scanning
- Secrets and credential management
- Compliance automation and reporting
- Security policy enforcement
- Vulnerability management integration
- Security monitoring and alerting

### Success Criteria:
- ✅ Security integrated throughout pipeline
- ✅ Automated compliance checking
- ✅ Comprehensive vulnerability management
- ✅ Secrets management best practices

---

## TC-INF-025: Multi-Cloud DevOps
**Objective**: Test multi-cloud DevOps implementation

### Primary Prompt:
```
Design a multi-cloud DevOps strategy that can deploy applications to AWS, Azure, and GCP 
based on cost, compliance, and performance requirements. Include unified pipeline management, 
environment provisioning, monitoring, and cost optimization across clouds. The solution 
must support disaster recovery and vendor lock-in mitigation.
```

### Expected Output:
- Multi-cloud DevOps architecture
- Unified pipeline and tooling strategy
- Cloud-agnostic deployment patterns
- Cross-cloud monitoring and observability
- Cost optimization and management
- Disaster recovery procedures
- Vendor lock-in mitigation strategies
- Unified security and compliance approach
