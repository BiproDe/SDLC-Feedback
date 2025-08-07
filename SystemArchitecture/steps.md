#### Step 1: Architecture Follow-up Questions

**For TC-INF-001 (E-commerce Platform Architecture):**
1. "What if we need to reduce the RTO to 30 minutes instead of 1 hour?"
2. "How would this architecture change if we expect 2 million daily users instead of 500K?"
3. "Can you provide specific Azure services and SKUs for each component?"
4. "How would you handle Black Friday traffic that's 20x normal volume?"
5. "What monitoring alerts would you set up for this architecture?"
6. "How would you implement the payment gateway integration securely?"
7. "What would be the estimated monthly cost for this architecture?"
8. "How would you handle database failover in the disaster recovery scenario?"

#### Step 2: Infrastructure as Code Follow-up Questions

**For TC-INF-001-IAC (Infrastructure as Code):**

1. "Can you generate separate Terraform modules for networking, AKS, and databases?"
2. "How would you implement environment-specific configurations (dev/staging/prod)?"
3. "What resource naming conventions and tagging strategies would you recommend?"
4. "Can you add proper variable definitions and outputs for the modules?"
5. "How would you handle sensitive values like connection strings and passwords?"
6. "Can you generate a terraform.tfvars.example file with all required variables?"
7. "How would you implement proper resource dependencies and ordering?"
8. "What Terraform state management strategy would you recommend for this project?"