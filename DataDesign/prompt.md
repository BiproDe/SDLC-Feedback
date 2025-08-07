# Data Design Document - Test Prompts

## TC-INF-005: Data Design - Multi-Region Database Strategy
**Objective**: Test database architecture and data management

### Primary Prompt:
```
Design a global data architecture for a SaaS application serving customers in North America, 
Europe, and Asia. Requirements include data locality compliance (GDPR), 24/7 availability, 
cross-region data synchronization, and the ability to handle 1TB of new data monthly. 
Include backup, archiving, and disaster recovery strategies.
```

### Expected Output:
- Multi-region database deployment strategy
- Data replication and synchronization approach
- GDPR compliance and data residency solutions
- Backup and archiving policies
- Performance optimization strategies
- Cost management and optimization
- Disaster recovery procedures
- Data migration strategies

### Success Criteria:
- ✅ Addresses global data distribution challenges
- ✅ Ensures GDPR and data locality compliance
- ✅ Provides robust backup and recovery strategy
- ✅ Optimizes for performance and cost

---

## Additional Data Design Test Scenarios

### TC-INF-015: Big Data Analytics Platform
**Objective**: Test big data architecture and analytics capabilities

### Primary Prompt:
```
Design a big data analytics platform for a retail company processing 10TB of transaction 
data daily, customer behavior data from web and mobile apps, and inventory data from 
500+ stores. The platform needs real-time analytics, batch processing, data lake storage, 
and machine learning capabilities. Include data governance, security, and cost optimization.
```

### Expected Output:
- Data lake and data warehouse architecture
- Real-time and batch processing pipelines
- Data ingestion and ETL strategies
- Analytics and reporting solutions
- Machine learning platform integration
- Data governance and quality framework
- Security and access control
- Cost optimization strategies

---

### TC-INF-016: Database Performance Optimization
**Objective**: Test database optimization and scaling strategies

### Primary Prompt:
```
A high-traffic web application database is experiencing performance issues. Current setup: 
PostgreSQL database with 2TB of data, 50K concurrent users, query response times averaging 
2-3 seconds (target: <200ms). The database handles 100K transactions per hour during peak 
times. Design a comprehensive database optimization and scaling strategy.
```

### Expected Output:
- Database performance analysis approach
- Query optimization strategies
- Database scaling solutions (vertical/horizontal)
- Caching strategies and implementation
- Database architecture improvements
- Monitoring and performance metrics
- Capacity planning recommendations

---

### TC-INF-017: Data Migration Strategy
**Objective**: Test complex data migration planning and execution

### Primary Prompt:
```
Plan a data migration from an on-premises Oracle database (500GB) to cloud-based PostgreSQL, 
with minimal downtime (max 4-hour maintenance window). The database supports a critical 
business application used by 10K+ users daily. Include data validation, rollback procedures, 
and post-migration optimization.
```

### Expected Output:
- Migration strategy and planning
- Data mapping and transformation approach
- Downtime minimization techniques
- Data validation and integrity checks
- Rollback and contingency procedures
- Performance optimization post-migration
- Testing and validation strategies
