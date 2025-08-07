# Data Design Testing Steps

## General Testing Approach

### Pre-Test Setup (5 minutes)
1. **Open VS Code**
2. **Open Copilot Chat** (`Ctrl+Shift+I`)
3. **Start new session** focused on data architecture
4. **Prepare timing tools**
5. **Have data design prompts ready**

### Test Execution Steps

#### Step 1: Initial Data Architecture Testing (10-15 minutes)
1. **Copy primary prompt** from prompt.md
2. **Paste into Copilot Chat**
3. **Record response time**
4. **Evaluate data architecture comprehensiveness**
5. **Rate database expertise level** (1-10 scale)

#### Step 2: Data-Specific Follow-up Questions (20-25 minutes)

**For TC-INF-005 (Multi-Region Database Strategy):**
1. "What specific database technologies would you recommend for each region?"
2. "How would you implement GDPR's 'right to be forgotten' across multiple regions?"
3. "What are the specific data synchronization patterns and technologies?"
4. "Can you provide database configuration scripts for multi-master replication?"
5. "How would you handle data conflicts in cross-region synchronization?"
6. "What specific backup retention policies would comply with different regional requirements?"
7. "How would you implement automated failover between regions?"
8. "What monitoring metrics are critical for multi-region database performance?"

**For TC-INF-015 (Big Data Analytics Platform):**
1. "What specific technologies would you use for the data lake (Hadoop, Spark, etc.)?"
2. "How would you implement real-time streaming analytics for transaction data?"
3. "What data partitioning strategy would you recommend for 10TB daily ingestion?"
4. "Can you provide sample ETL pipeline configurations?"
5. "How would you implement data lineage and governance across the platform?"
6. "What machine learning frameworks would you integrate?"
7. "How would you handle data quality issues and anomaly detection?"
8. "What cost optimization strategies are specific to big data platforms?"

**For TC-INF-016 (Database Performance Optimization):**
1. "What specific database indexes would you recommend for this workload?"
2. "How would you implement database sharding for horizontal scaling?"
3. "What caching layers and strategies would you implement?"
4. "Can you provide specific PostgreSQL configuration optimizations?"
5. "How would you implement connection pooling for 50K concurrent users?"
6. "What database monitoring queries and alerts would you set up?"
7. "How would you implement read replicas for load distribution?"
8. "What are the specific query optimization techniques?"

**For TC-INF-017 (Data Migration Strategy):**
1. "What tools would you use for Oracle to PostgreSQL migration?"
2. "How would you handle data type mappings and schema differences?"
3. "What specific validation queries would you run pre and post-migration?"
4. "Can you provide migration scripts and procedures?"
5. "How would you implement near-zero downtime migration techniques?"
6. "What rollback procedures would you have in place?"
7. "How would you handle application compatibility during migration?"
8. "What performance benchmarks would you establish?"

#### Step 3: Deep Data Architecture Testing (15-20 minutes)

**Database Design Deep Dive:**
1. "Can you design the specific database schema for this use case?"
2. "What indexing strategy would you implement?"
3. "How would you handle database normalization vs. denormalization decisions?"

**Performance and Scalability:**
1. "How would you design for 10x growth in data volume?"
2. "What are the specific performance bottlenecks you would monitor?"
3. "How would you implement database auto-scaling?"

**Data Governance and Security:**
1. "What data classification and protection strategies would you implement?"
2. "How would you implement row-level security and data masking?"
3. "What audit trail and compliance reporting would you set up?"

**Backup and Recovery:**
1. "Can you provide detailed backup and recovery procedures?"
2. "How would you test disaster recovery scenarios?"
3. "What are the specific RPO/RTO targets and how would you achieve them?"

#### Step 4: Practical Implementation Testing (10-15 minutes)

**Request Specific Configurations:**
1. **Database Scripts**: "Generate database creation and configuration scripts"
2. **ETL Pipelines**: "Provide data pipeline configurations"
3. **Monitoring Queries**: "Create database performance monitoring queries"
4. **Migration Scripts**: "Generate data migration and validation scripts"

**Test Complex Scenarios:**
1. "How do you handle database corruption scenarios?"
2. "What if the primary region becomes unavailable for 24 hours?"
3. "How do you manage schema changes across multiple environments?"

## Data Design Evaluation Criteria

### Database Expertise (1-10 Scale)
- **9-10**: Expert database knowledge, advanced optimization techniques
- **7-8**: Strong database skills with good architectural understanding
- **5-6**: Basic database knowledge but misses advanced concepts
- **3-4**: Limited database understanding
- **1-2**: Poor database knowledge with potential design flaws

### Data Architecture Design (1-10 Scale)
- **9-10**: Comprehensive data architecture addressing all requirements
- **7-8**: Good data design with minor gaps
- **5-6**: Basic data architecture but misses important elements
- **3-4**: Limited architectural thinking
- **1-2**: Poor data design with major flaws

### Performance & Scalability (1-10 Scale)
- **9-10**: Excellent performance optimization and scaling strategies
- **7-8**: Good performance considerations with practical solutions
- **5-6**: Basic performance awareness but limited optimization
- **3-4**: Minimal performance considerations
- **1-2**: Poor or no performance optimization

### Data Governance & Compliance (1-10 Scale)
- **9-10**: Comprehensive data governance with regulatory compliance
- **7-8**: Good governance approach with compliance awareness
- **5-6**: Basic governance understanding
- **3-4**: Limited governance considerations
- **1-2**: Poor or missing data governance

## Critical Data Elements to Verify

### Database Design
- ✅ Appropriate database technology selection
- ✅ Proper data modeling and schema design
- ✅ Indexing and query optimization strategies
- ✅ Data partitioning and sharding approaches

### Performance & Scalability
- ✅ Horizontal and vertical scaling strategies
- ✅ Caching mechanisms and implementation
- ✅ Connection pooling and resource management
- ✅ Performance monitoring and alerting

### Data Protection & Security
- ✅ Encryption at rest and in transit
- ✅ Access control and authentication
- ✅ Data masking and anonymization
- ✅ Audit trails and compliance logging

### Backup & Recovery
- ✅ Backup strategies and retention policies
- ✅ Point-in-time recovery capabilities
- ✅ Disaster recovery procedures
- ✅ Recovery time and point objectives

### Data Integration
- ✅ ETL/ELT pipeline design
- ✅ Data quality and validation processes
- ✅ Data lineage and metadata management
- ✅ Integration with analytics and reporting tools

## Red Flags in Data Design

### Major Concerns:
- ❌ Single points of failure in data architecture
- ❌ Inadequate backup and recovery strategies
- ❌ Poor performance optimization approaches
- ❌ Missing data security and encryption
- ❌ Inadequate compliance considerations
- ❌ Poor data quality management
- ❌ Unrealistic scaling assumptions

### Documentation Template

**Data Design Test Result:**
```markdown
# Data Design Test Result

**Test Case**: [TC-INF-XXX]
**Date**: [Date]
**Data Focus Area**: [Multi-Region/Big Data/Performance/Migration]
**Duration**: [Total Time]

## Data Architecture Assessment
- **Database Expertise**: [X/10]
- **Data Architecture Design**: [X/10]
- **Performance & Scalability**: [X/10]
- **Data Governance & Compliance**: [X/10]

## Specific Data Strengths
- [Database technology recommendations]
- [Performance optimization strategies]
- [Data governance approaches]
- [Backup and recovery solutions]

## Data Design Gaps
- [Missing database considerations]
- [Performance optimization gaps]
- [Governance and compliance issues]
- [Scalability concerns]

## Technical Implementation
**Code Quality**: [Generated scripts/configurations quality]
**Practical Applicability**: [Real-world implementation feasibility]
**Best Practices**: [Adherence to database best practices]

## Business Impact
**Data Reliability**: [High/Medium/Low]
**Performance Impact**: [Significant/Moderate/Minimal]
**Scalability Assessment**: [Excellent/Good/Poor]
**Cost Implications**: [Optimized/Reasonable/Expensive]

## Recommendations
- [Database improvements needed]
- [Performance optimizations required]
- [Governance enhancements]
- [Additional testing recommendations]
```

## Data Testing Success Tips

1. **Focus on Data Integrity**: Ensure data consistency and accuracy
2. **Consider Performance at Scale**: Test scalability assumptions
3. **Validate Compliance**: Verify regulatory requirement adherence
4. **Test Recovery Scenarios**: Ensure backup and recovery procedures work
5. **Evaluate Cost Implications**: Consider long-term data storage costs
6. **Check Integration Points**: Validate data flow between systems
7. **Consider Operational Complexity**: Assess day-to-day management requirements
