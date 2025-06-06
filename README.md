
# 🧩 Cascadeforce

**Cascadeforce** is an Apex utility class for performing cascade deletes in Salesforce. Given a record or list of records, it identifies and optionally deletes all related child records based on relationship queries. It supports access-level controls and transaction safety via `allOrNone` flags.

---

## 📌 Features

- 🔄 Finds and deletes related child records
- 🔐 Supports access-level filtering (e.g. USER_MODE, SYSTEM_MODE)
- ✅ Allows optional `allOrNone` behavior for transactional consistency
- 📦 Pure Apex utility, easy to deploy and use

---

## 🧠 Public Methods

### [Cascadeforce](docs/miscellaneous/Cascadeforc.md)

### 🔍 `getRelatedRecords(recordIds)`

```apex
public static List<Id> getRelatedRecords(List<Id> recordIds)
```

| Parameter   | Type      | Description                                                              |
|-------------|-----------|--------------------------------------------------------------------------|
| `recordIds` | `List<Id>`| A list of record IDs (same object type) to find related child records for |

**Returns:** `List<Id>` — related child record IDs.

---

### 🔍 `getRelatedRecords(recordIds, accessLevel)`

```apex
public static List<Id> getRelatedRecords(List<Id> recordIds, AccessLevel accessLevel)
```

| Parameter     | Type         | Description                                                        |
|---------------|--------------|--------------------------------------------------------------------|
| `recordIds`   | `List<Id>`   | A list of record IDs to search (same object type)                 |
| `accessLevel` | `AccessLevel`| Level of access required for the records (e.g., USER_MODE)         |

**Returns:** `List<Id>` — filtered child record IDs based on access level.

---

### 🗑️ `deleteRelatedRecords(recordIds)`

```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds)
```

| Parameter   | Type      | Description                                                              |
|-------------|-----------|--------------------------------------------------------------------------|
| `recordIds` | `List<Id>`| Record IDs whose children should be deleted                             |

**Returns:** `List<Database.DeleteResult>` — result of the delete operations.

---

### 🗑️ `deleteRelatedRecords(recordIds, allOrNone)`

```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone)
```

| Parameter   | Type      | Description                                                              |
|-------------|-----------|--------------------------------------------------------------------------|
| `recordIds` | `List<Id>`| Record IDs whose children should be deleted                             |
| `allOrNone` | `Boolean` | If `true`, all deletes succeed or all fail together                     |

**Returns:** `List<Database.DeleteResult>` — transactional delete result list.

---

### 🗑️ `deleteRelatedRecords(recordIds, accessLevel)`

```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, AccessLevel accessLevel)
```

| Parameter     | Type         | Description                                                        |
|---------------|--------------|--------------------------------------------------------------------|
| `recordIds`   | `List<Id>`   | Record IDs to delete child records for                            |
| `accessLevel` | `AccessLevel`| Required access level for deletion                                 |

**Returns:** `List<Database.DeleteResult>` — delete results based on access level.

---

### 🗑️ `deleteRelatedRecords(recordIds, allOrNone, accessLevel)`

```apex
public static List<Database.DeleteResult> deleteRelatedRecords(List<Id> recordIds, Boolean allOrNone, AccessLevel accessLevel)
```

| Parameter     | Type         | Description                                                        |
|---------------|--------------|--------------------------------------------------------------------|
| `recordIds`   | `List<Id>`   | Record IDs whose related records will be deleted                  |
| `allOrNone`   | `Boolean`    | Apply full transaction rollback if any delete fails               |
| `accessLevel` | `AccessLevel`| Minimum access required to delete a record                         |

**Returns:** `List<Database.DeleteResult>` — full transactional and filtered delete result.

---

## 🧾 Example Usage

```java
List<Id> allChildIds = Cascadeforce.getRelatedRecords(
    new List<Id>{'001xx000003DGXAAA4'}, AccessLevel.USER_MODE
);

List<Database.DeleteResult> results = Cascadeforce.deleteRelatedRecords(
    new List<Id>{'001xx000003DGXAAA4'}, true, AccessLevel.USER_MODE
);
```

## Trigger Usage
That's only a simple example of how to use Cascadeforce in a trigger context. You shouldn't use it directly on the trigger file, it should be used in a separate class that handles the logic.

```java
trigger AccountTrigger on Account (before delete) {
    Cascadeforce.deleteRelatedRecords(new List<Id>(Trigger.oldMap.keySet()));
}
```
---

## 🔧 Deployment

```bash
sf project deploy start -x manifest/package.xml -l RunSpecifiedTests -t CascadeforceTest
```

---

## 🤝 Contributions

Pull requests and issues are welcome!
