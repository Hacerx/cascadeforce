# Cascadeforce Class

## Methods
### `getRelatedRecords(recordIds)`

This method retrieves related records for a given list of record IDs.

#### Signature
```apex
public static List<Id> getRelatedRecords(List<Id> recordIds)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be fetched (all recordIds should be of the same object). |

#### Return Type
**List&lt;Id&gt;**

A list of related record IDs.

---

### `getRelatedRecords(recordIds, accessLevel)`

This method retrieves related records for a given list of record IDs.

#### Signature
```apex
public static List<Id> getRelatedRecords(List<Id> recordIds, AccessLevel accessLevel)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be fetched (all recordIds should be of the same object). |
| accessLevel | AccessLevel | The access level for the operation (e.g., USER_MODE, SYSTEM_MODE). |

#### Return Type
**List&lt;Id&gt;**

A list of related record IDs.

---

### `deleteRelatedRecords(recordIds)`

This method deletes related records for a given list of record IDs.

#### Signature
```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be deleted (all recordIds should be of the same object). |

#### Return Type
**List&lt;Database.DeleteResult&gt;**

DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.

---

### `deleteRelatedRecords(recordIds, allOrNone)`

This method deletes related records for a given list of record IDs with options for transaction control.

#### Signature
```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be deleted (all recordIds should be of the same object). |
| allOrNone | Boolean | If true, the operation will either succeed for all records or fail for all records. |

#### Return Type
**List&lt;Database.DeleteResult&gt;**

DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.

---

### `deleteRelatedRecords(recordIds, accessLevel)`

This method deletes related records for a given list of record IDs with options for transaction control and access level.

#### Signature
```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, AccessLevel accessLevel)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be deleted (all recordIds should be of the same object). |
| accessLevel | AccessLevel | The access level for the operation (e.g., USER_MODE, SYSTEM_MODE). |

#### Return Type
**List&lt;Database.DeleteResult&gt;**

DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.

---

### `deleteRelatedRecords(recordIds, allOrNone, accessLevel)`

This method deletes related records for a given list of record IDs with options for transaction control and access level.

#### Signature
```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone, AccessLevel accessLevel)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIds | List&lt;Id&gt; | A list of record IDs for which related records are to be deleted (all recordIds should be of the same object). |
| allOrNone | Boolean | If true, the operation will either succeed for all records or fail for all records. |
| accessLevel | AccessLevel | The access level for the operation (e.g., USER_MODE, SYSTEM_MODE). |

#### Return Type
**List&lt;Database.DeleteResult&gt;**

DeleteResult A list of Database.DeleteResult objects indicating the success or failure of each delete operation.