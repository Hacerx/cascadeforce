public with sharing class Cascadeforce {
    /**
     * This method retrieves related records for a given list of record IDs.
     * @param recordIds A list of record IDs for which related records are to be fetched (all recordIds should be of the same object).
     * @return A list of related record IDs.
     */
    public static List<Id> getRelatedRecords(List<Id> recordIds) {
        return getRelatedRecords(recordIds, AccessLevel.USER_MODE);
    }

    /**
     * This method retrieves related records for a given list of record IDs.
     * @param recordIds A list of record IDs for which related records are to be fetched (all recordIds should be of the same object).
     * @param accessLevel The access level for the operation (e.g., USER_MODE, SYSTEM_MODE).
     * @return A list of related record IDs.
     */
    public static List<Id> getRelatedRecords(List<Id> recordIds, AccessLevel accessLevel) {
        List<Id> relatedRecordIds = new List<Id>();
        if(recordIds == null || recordIds.isEmpty()) {
            return relatedRecordIds; // Return empty list if input is null or empty
        }

        // get sobject type from id
        Schema.DescribeSObjectResult sObjectDescribe = recordIds[0].getSObjectType().getDescribe();
        List<String> childRelationshipNames = new List<String>();
        
        for(Schema.ChildRelationship childRel : sObjectDescribe.getChildRelationships()) {
            String childRelationshipName = childRel.getRelationshipName();
            // Check if the relationship name is valid (standard or custom, without __History or __Share)
            if (!childRel.isCascadeDelete() && !String.isBlank(childRelationshipName) && (childRelationshipName.contains('__r') || !childRelationshipName.contains('__'))) {
                childRelationshipNames.add(childRelationshipName);
            }
        }        

        /**
         * Bypass
         * System.QueryException: SOQL statements cannot query more than 20 different child types.
         */
        Integer batchSize = 20;
        Integer totalBatches = (Integer)Math.ceil(childRelationshipNames.size() / (Decimal)batchSize);

        for (Integer start = 0; start < totalBatches * batchSize; start += batchSize) {
            List<String> currentBatch = new List<String>();
            for (Integer j = start; j < Math.min(start + batchSize, childRelationshipNames.size()); j++) {
                currentBatch.add(childRelationshipNames[j]);
            }

            // Construir la query dinámica
            List<String> subqueries = new List<String>();
            for (String relName : currentBatch) {
                subqueries.add('(SELECT Id FROM ' + relName + ')');
            }

            String query = 'SELECT ' + String.join(subqueries, ', ');
            query += ' FROM ' + sObjectDescribe.getName() + ' WHERE Id IN :recordIds';

            List<SObject> records = Database.query(query, accessLevel);

            for (SObject record : records) {
                for (String relName : currentBatch) {
                    List<SObject> children = (List<SObject>)record.getSObjects(relName);
                    if (children != null && !children.isEmpty()) {
                        for (SObject child : children) {
                            relatedRecordIds.add(child.Id);
                        }
                    }
                }
            }
        }

        return relatedRecordIds;
    }


    /**
     * This method deletes related records for a given list of record IDs.
     * @param recordIds A list of record IDs for which related records are to be deleted (all recordIds should be of the same object).
     * @return DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.
     */
    public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds) {
        return deleteRelatedRecords(recordIds, true, AccessLevel.USER_MODE);
    }

    /**
     * This method deletes related records for a given list of record IDs with options for transaction control.
     * @param recordIds A list of record IDs for which related records are to be deleted (all recordIds should be of the same object).
     * @param allOrNone If true, the operation will either succeed for all records or fail for all records.
     * @return DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.
     */
    public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone) {
        return deleteRelatedRecords(recordIds, allOrNone, AccessLevel.USER_MODE);
    }

    /**
     * This method deletes related records for a given list of record IDs with options for transaction control and access level.
     * @param recordIds A list of record IDs for which related records are to be deleted (all recordIds should be of the same object).
     * @param accessLevel The access level for the operation (e.g., USER_MODE, SYSTEM_MODE).
     * @return DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.
     */
    public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, AccessLevel accessLevel){
        return deleteRelatedRecords(recordIds, true, accessLevel);
    }

    /**
     * This method deletes related records for a given list of record IDs with options for transaction control and access level.
     * @param recordIds A list of record IDs for which related records are to be deleted (all recordIds should be of the same object).
     * @param allOrNone If true, the operation will either succeed for all records or fail for all records.
     * @param accessLevel The access level for the operation (e.g., USER_MODE, SYSTEM_MODE).
     * @return DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.
     */
    public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone, AccessLevel accessLevel) {
        if(recordIds == null || recordIds.isEmpty()) {
            return new List<Database.DeleteResult>(); // Return empty list if input is null or empty
        }
        List<Id> relatedRecordIds = getRelatedRecords(recordIds);
        return Database.delete(relatedRecordIds, allOrNone, accessLevel);
    }
}