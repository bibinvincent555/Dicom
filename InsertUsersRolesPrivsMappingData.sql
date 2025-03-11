
USE `pacsdb`;

TRUNCATE TABLE medvuser_medvroles_map;
TRUNCATE TABLE medvroles_medvprivileges_map;
TRUNCATE TABLE medv_user;
TRUNCATE TABLE medv_roles;
TRUNCATE TABLE medv_privileges;

INSERT  INTO `medv_user`(`id`,`user_id`,`passwd`,`privilege_hash`) VALUES (1,'admin','d033e22ae348aeb5660fc2140aec35850c4da997',1079854830),(2,'sa','889a3a791b3875cfae413574b53da4bb8a90d53e',1139478759);


INSERT  INTO `medv_privileges`(`id`,`privilege_name`) VALUES (1,'PERM_MANAGE_AEDETAILS'),(2,'PERM_UPDATE_AEDETAILS'),(3,'PERM_DELETE_AEDETAILS'),(4,'PERM_ADD_AEDETAILS'),(5,'PERM_CHANGE_PASSWORD'),(6,'PERM_MANAGE_MWL'),(7,'PERM_USER_PRIVILEGE'),(8,'PERM_STORAGE_SERVICE'),(9,'PERM_QUERY_RETRIEVE_SERVICE');


INSERT  INTO `medv_roles`(`id`,`roles`) VALUES (1,'ROLE_Admin_APACSWebAdmin'),(2,'ROLE_SA_Super');


INSERT  INTO `medvroles_medvprivileges_map`(`id`,`role_id`,`privilege_id`) VALUES (1,1,1),(2,1,2),(4,1,7),(5,2,1),(6,2,2),(7,2,3),(8,2,4),(9,2,5),(10,2,6),(11,2,7),(12,2,8),(13,2,9);


INSERT  INTO `medvuser_medvroles_map`(`id`,`user_id`,`roles`) VALUES (1,'sa','ROLE_SA_Super'),(2,'admin','ROLE_Admin_APACSWebAdmin');



