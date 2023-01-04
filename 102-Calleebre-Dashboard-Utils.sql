-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
-- Utilities
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

-- new sponsor|null,   new campaign|null,   file_id, new file_id|null, new file_name|null, legacy flag, comments
-- ( null, null, '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', 'Yallo MNP - 2022-05 (May)', false, null ),


drop table if exists dashboards.migration_files_mapping;
create table if not exists dashboards.migration_files_mapping (
	-- --------------------------------------------------------------------------------
	sponsor_new varchar(256),									-- or null if keeping 'Ganira'
	campaign_alt varchar(256), 									-- or null if keeping default campaign mapping
	file_id char(36) primary key,								-- as per original mapping in model
--	file_id uuid primary key,									-- as per original mapping in model
	file_id_new char(36),										-- new mapping in model
--	file_id_new uuid,											-- new mapping in model
	file_name varchar(256), 									-- new file name
	legacy_flag boolean,										-- wether the file shall be archived
	comments varchar(1024)										-- whatever comment, for example regarding checks to be performed before the migration or alternative mappings
);

-- --------------------------------------------------------------------------------

delete from dashboards.migration_files_mapping where 1=1;
insert into dashboards.migration_files_mapping (sponsor_new, campaign_alt, file_id, file_id_new, file_name, legacy_flag, comments) values 
	( null, null, '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', 'Yallo MNP - 2022-05 (May)', false, null ),
	( null, null, '1cece920-d2ca-4a88-892b-82a24dabaea4', '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', 'Yallo MNP - 2022-05 (May)', false, null ),
	( null, null, 'a3104d42-f726-4a08-9989-368bea5117a5', '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', 'Yallo MNP - 2022-05 (May)', false, null ),
	( 'LEGACY', null, '4d5ef9a6-85bc-452f-a8d4-637abfe9ff08', null, null, true, null ),
	( null, null, 'f243109d-3059-4422-8065-665c0b222d2c', '7f5ce2db-1ed0-4a20-9b9a-ce5beee89b36', 'Yallo MNP - 2022-05 (May)', false, null ),
	( null, null, 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'Yallo MNP - 2022-06 (June)', false, null ),
	( null, null, '5b87e770-e25d-4c28-ab8a-12f8aef46eaa', 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'Yallo MNP - 2022-06 (June)', false, null ),
	( 'LEGACY', null, '9d0ae309-5d29-4a7e-a1e5-acf5cf5b6811', null, null, true, null ),
	( null, null, '51c9c6ed-b35a-4aa8-ac5c-c5349d4528fc', 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'Yallo MNP - 2022-06 (June)', false, null ),
	( 'LEGACY', null, 'dec329e4-1d57-4258-a8e7-7494584122e3', null, null, true, null ),
	( 'LEGACY', null, '68a97122-e24c-4216-9c69-509980d43a2d', null, null, true, null ),
	( null, null, '93cfaf05-3b77-4e0e-a85a-20f6408cdbb5', 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'Yallo MNP - 2022-06 (June)', false, null ),
	( null, null, 'a6d0c6fb-e2c1-42e6-8deb-db65cfa5f3bd', 'e6e8eaf5-8193-4b06-b7e7-b01d35796482', 'Yallo MNP - 2022-06 (June)', false, null ),
	( null, null, 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, 'c90d06c1-7bf0-4426-a307-142a94965fd5', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, 'b774132c-9a7a-494d-a36e-a7956772c058', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, '61da6643-2146-4ada-96c6-b5733939577e', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, '4706f15a-58a9-4d5f-b4b8-a5eed24e150c', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, '295c19ea-2f56-4b71-a67c-e6e092d96c02', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, '79b5aad4-826f-4d34-8f6d-773bfff7b92c', '79b5aad4-826f-4d34-8f6d-773bfff7b92c', 'Yallo MNP - 2022-08 (August)', false, null ),
	( null, null, '43b8e3b8-470d-4fec-9bb1-d81d36d23fdc', '79b5aad4-826f-4d34-8f6d-773bfff7b92c', 'Yallo MNP - 2022-08 (August)', false, null ),
	( null, null, '30658c81-12c9-4db7-b177-8b6a00e0048b', '79b5aad4-826f-4d34-8f6d-773bfff7b92c', 'Yallo MNP - 2022-08 (August)', false, null ),
	( null, null, '4765df8e-f517-40d8-a12c-10467d4cb14c', '79b5aad4-826f-4d34-8f6d-773bfff7b92c', 'Yallo MNP - 2022-08 (August)', false, null ),
	( null, null, '516ac588-1900-4685-9b9b-dc52bfbb1a66', '79b5aad4-826f-4d34-8f6d-773bfff7b92c', 'Yallo MNP - 2022-08 (August)', false, null ),
	( null, null, '979e80ac-ead3-4291-b449-5c03e55684a3', '979e80ac-ead3-4291-b449-5c03e55684a3', 'Yallo MNP - 2022-09 (September)', false, null ),
	( null, null, 'c497c4dd-f806-4605-a523-551116fff49f', '979e80ac-ead3-4291-b449-5c03e55684a3', 'Yallo MNP - 2022-09 (September)', false, null ),
	( null, null, 'e570ddbd-441d-4425-8643-4042adfee901', '979e80ac-ead3-4291-b449-5c03e55684a3', 'Yallo MNP - 2022-09 (September)', false, null ),
	( null, null, '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, '015d0d19-761c-4e78-bab9-f2c2cb217c16', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'ecf55c8a-6983-454c-9561-83d5e4a44826', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'f2d4e8e6-a551-41fe-b366-638974776936', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, '0d3e284d-43fe-4b09-b2a1-f177cfdde6af', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'dca8166c-430c-416c-907c-29cee1576a92', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, '4de64eed-1736-4367-b1a3-ba20322fca71', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'ada38de6-53d4-4e2c-b107-4c418705c1e8', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'c40a2f6f-4e47-412f-9d77-febcb4f1a053', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, '6f33b524-a0dc-485a-9909-d842fc365f96', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, 'dd121f1a-4199-4bf5-9269-c8d90334fb10', '797e18cb-d90d-419e-b0ab-3d3fb7c6d094', 'Yallo MNP - 2022-10 (October)', false, null ),
	( null, null, '19458807-7c78-45f2-a5da-faf32361b1ab', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, '0d4b9729-67ab-4693-bafb-aa50dbcb5141', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, '314422ba-30ac-499a-b343-478a07f5b3ef', '314422ba-30ac-499a-b343-478a07f5b3ef', 'Yallo MNP - 2022-11 (November) - Recycled 2022-10', false, null ),
	( null, null, 'd50230ea-5b0c-4261-9c07-2f2bb4d4cbf6', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, '3611bec1-4fe8-4e00-95ad-a9befeac9ac8', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, 'be5670d7-6e1b-43d0-962b-d5b1bd7fda8f', 'be5670d7-6e1b-43d0-962b-d5b1bd7fda8f', 'Yallo MNP - 2022-11 (November) - Recycled 2022-08', false, null ),
	( null, null, '3fbd659c-907a-4baa-a0ff-87f6f497f478', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, 'd6f9f403-c362-48fc-a020-f3a5c83492de', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, '117a8647-b645-40ad-a92c-b3f4be245aa4', '19458807-7c78-45f2-a5da-faf32361b1ab', 'Yallo MNP - 2022-11 (November)', false, null ),
	( null, null, '126c271e-5434-4410-8bcb-57eb5ff5e9e0', '126c271e-5434-4410-8bcb-57eb5ff5e9e0', 'Yallo Contest - 2022-03 (March)', false, null ),
	( 'LEGACY', null, 'bbb17868-de7a-44ba-8cd4-1e5ca3a26271', null, null, true, null ),
	( 'LEGACY', null, 'a2bddd05-9cf0-4a30-84c1-d41f93ceb650', null, null, true, null ),
	( 'LEGACY', null, '2b819f03-bc7f-4be3-808d-2233ccee3a44', null, null, true, null ),
	( null, null, 'd15964d6-92a8-463d-b163-7683359fc96b', 'd15964d6-92a8-463d-b163-7683359fc96b', 'Yallo Contest - 2022-04 (April)', false, null ),
	( null, null, 'e22e8fd4-aa75-43e2-b743-f3582be7f090', 'd15964d6-92a8-463d-b163-7683359fc96b', 'Yallo Contest - 2022-04 (April)', false, null ),
	( null, null, '222de5f6-12b1-453b-b75e-716e829cfd40', 'd15964d6-92a8-463d-b163-7683359fc96b', 'Yallo Contest - 2022-04 (April)', false, null ),
	( null, null, 'bc1ed732-d870-4e1d-a9a8-27b3071050a6', 'd15964d6-92a8-463d-b163-7683359fc96b', 'Yallo Contest - 2022-04 (April)', false, null ),
	( null, null, 'a432c336-84f9-4c57-a844-dc1bf436f7ae', 'a432c336-84f9-4c57-a844-dc1bf436f7ae', 'Yallo Contest - 2022-05 (May)', false, null ),
	( null, null, '2ca89eee-c0fe-41e5-9901-8e7ec0811206', '2ca89eee-c0fe-41e5-9901-8e7ec0811206', 'Yallo Contest - 2022-05 (May) - Special', false, null ),
	( null, null, '0336e50f-9e57-4043-8478-e14abd132b3e', '0336e50f-9e57-4043-8478-e14abd132b3e', 'Yallo Contest - 2022-07 (July)', false, null ),
	( null, null, '4b77cb95-8aac-4e19-8005-44e6909d5100', '4b77cb95-8aac-4e19-8005-44e6909d5100', 'Yallo Contest - 2022-05_07 (May-July)', false, null ),
	( null, null, 'f96c9ffb-b832-4c58-a688-ed0cecba7f3d', '4b77cb95-8aac-4e19-8005-44e6909d5100', 'Yallo Contest - 2022-05_07 (May-July)', false, null ),
	( null, null, 'fa0f90c6-7940-4060-86a7-e050fcdeb650', 'fa0f90c6-7940-4060-86a7-e050fcdeb650', 'Yallo Contest - 2022-08 (August)', false, null ),
	( 'LEGACY', null, 'c3cc7ffe-8844-4075-b087-26468bb8af95', null, null, true, null ),
	( null, null, '669932f4-716a-4823-9277-99270431339c', '669932f4-716a-4823-9277-99270431339c', 'Yallo Contest - 2022-08 (August) - No Name', false, null ),
	( null, null, 'bd96dfa3-48e8-4c1a-ae4f-568781ba1413', 'fa0f90c6-7940-4060-86a7-e050fcdeb650', 'Yallo Contest - 2022-08 (August)', false, null ),
	( null, null, '29e8d1e1-cb66-4f2d-9841-9dbecba2ec44', 'fa0f90c6-7940-4060-86a7-e050fcdeb650', 'Yallo Contest - 2022-08 (August)', false, null ),
	( null, null, '37832989-6dd5-4336-8405-c0828b8c1198', '37832989-6dd5-4336-8405-c0828b8c1198', 'Yallo Contest - 2022-09 (September)', false, null ),
	( null, null, '4d5eb5b4-b780-4088-bc0d-beaf2c08888b', '37832989-6dd5-4336-8405-c0828b8c1198', 'Yallo Contest - 2022-09 (September)', false, null ),
	( null, null, 'e2438547-38ea-498e-bedc-241c1f579c5f', 'e2438547-38ea-498e-bedc-241c1f579c5f', 'Yallo Contest - 2022-10 (October)', false, null ),
	( null, 'Abandoned Baskets', '09d5ccbb-b01f-47a8-a023-693dade9611f', '09d5ccbb-b01f-47a8-a023-693dade9611f', 'Yallo Abandoned Baskets - 2022-10 (October)', false, null ),
	( null, null, '5ef4bc8d-8c5b-4aa3-bd15-0628213741d9', '37832989-6dd5-4336-8405-c0828b8c1198', 'Yallo Contest - 2022-09 (September)', false, null ),
	( null, null, '28af09ee-f159-472e-9fdb-402a7816f11e', '28af09ee-f159-472e-9fdb-402a7816f11e', 'Yallo Contest - 2022-11 (November) - Recycled 2022-04', false, null ),
	( null, null, '75ed39e0-9dcd-45fe-960a-67f78abad574', '28af09ee-f159-472e-9fdb-402a7816f11e', 'Yallo Contest - 2022-11 (November) - Recycled 2022-04', false, null ),
	( null, null, '22208977-5e4a-4701-99f2-7045cd1de065', '28af09ee-f159-472e-9fdb-402a7816f11e', 'Yallo Contest - 2022-11 (November) - Recycled 2022-04', false, null ),
	( null, null, '2711bd04-35cf-47c2-829d-610c1c6ba86d', '28af09ee-f159-472e-9fdb-402a7816f11e', 'Yallo Contest - 2022-11 (November) - Recycled 2022-04', false, null ),
	( null, null, 'c54516cd-f8e4-4bc1-972f-26292018cbd1', 'c54516cd-f8e4-4bc1-972f-26292018cbd1', 'Yallo Abandoned Baskets - 2022-04 (April)', false, null ),
	( null, null, '05b64f2a-aee8-4df6-8795-aefaab23ffb1', '05b64f2a-aee8-4df6-8795-aefaab23ffb1', 'Yallo Abandoned Baskets - 2022-05 (May)', false, null ),
	( null, null, 'f319b562-1a53-454c-908c-b4a8154f942e', '05b64f2a-aee8-4df6-8795-aefaab23ffb1', 'Yallo Abandoned Baskets - 2022-05 (May)', false, null ),
	( null, null, '3eeaf81a-19bc-42dd-91f0-4d1d9e063075', '05b64f2a-aee8-4df6-8795-aefaab23ffb1', 'Yallo Abandoned Baskets - 2022-05 (May)', false, null ),
	( null, null, 'ccb21b5f-672e-4f20-af78-a199cba44ffd', '05b64f2a-aee8-4df6-8795-aefaab23ffb1', 'Yallo Abandoned Baskets - 2022-05 (May)', false, null ),
	( null, null, 'e5390c76-be83-4757-8386-69286050ecf3', 'e5390c76-be83-4757-8386-69286050ecf3', 'Yallo Abandoned Baskets - 2022-05 (May) - Recycled', false, null ),
	( null, null, 'c1a54a12-d5b9-45ff-a182-1c1d8cc5f446', 'c1a54a12-d5b9-45ff-a182-1c1d8cc5f446', 'Yallo Abandoned Baskets - 2022-06 (June)', false, null ),
	( null, null, '4fff14cc-33d5-4b7b-8a5d-3d5b3901af4b', '4fff14cc-33d5-4b7b-8a5d-3d5b3901af4b', 'Yallo Abandoned Baskets - 2022-06 (June) - Summer BlackFriday', false, null ),
	( null, null, 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, 'a0385cbc-8116-48d5-b910-ec74c84de86f', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, '78d18738-7819-4953-83e0-c5e953f51215', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, '406b0df1-532c-4b99-8497-f33555c4d82a', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, 'cbf8254d-5e77-49a7-99dd-a97c369551f7', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( 'LEGACY', null, 'f4c29d49-3a1a-4363-96df-4439e59b0b05', null, null, true, null ),
	( null, null, '384d049b-0bd5-4652-a800-cbef23cccdc2', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Check date & month' ),
	( null, null, '7ff30304-ee7c-4b49-b10d-789af7d78b52', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, 'e7f3f2aa-7686-41e4-a19e-022a1c9291b9', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Check date & month' ),
	( null, null, '5cb48c82-aa89-4668-bc7d-1ad986c7d772', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Check date & month' ),
	( null, null, '9513dd30-c624-46e9-bebf-d0a36ae58c85', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Looks like a real file, was it used?' ),
	( null, null, '9d5ef7d5-eec4-4788-91c1-b900827d99b0', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Check date & month' ),
	( null, null, 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '203132d5-02e7-4053-b621-043867cbf9b2', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '3b33a55d-bc57-49a0-9f1e-28f785740c4f', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, 'fb0752de-8ada-4437-9458-c28b7892db89', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, 'Check date & month' ),
	( null, null, 'd675a213-fdc4-4c94-803e-e5c43d6f4469', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '60e8be8b-f7f4-4626-883e-22de6476708e', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '24a2baca-677a-40c4-8423-ee78c28d96b6', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '928045dc-ce98-4b3b-963a-5f9d7fe420c2', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, 'Looks like a real file, was it used?' ),
	( null, null, '454b2fc8-b490-41be-bfa9-b78b103f10ed', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, 'f7057699-8352-47ea-9f30-1b1629c068df', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, 'a6d2dd1d-dfa9-4301-8e19-86a554e6a801', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, 'ac373208-be19-44d1-a71c-f4abc94ce886', 'bca02601-8759-417d-9e6b-baccc7d9ec86', 'Yallo Abandoned Baskets - 2022-08 (August)', false, null ),
	( null, null, '6c238ded-b9fc-4422-ae3f-512c6de475a1', '6c238ded-b9fc-4422-ae3f-512c6de475a1', 'Yallo Abandoned Baskets - 2022-09 (September)', false, null ),
	( null, 'Contest', 'e37b896d-834d-4c37-8497-aec9c668a7af', 'e2438547-38ea-498e-bedc-241c1f579c5f', 'Yallo Contest - 2022-10 (October)', false, null ),
	( null, null, '6af9d4cd-d112-4a0f-b269-70e315b20593', '09d5ccbb-b01f-47a8-a023-693dade9611f', 'Yallo Abandoned Baskets - 2022-10 (October)', false, null ),
	( null, null, '682da91e-37b9-40d2-865b-5077f40ba673', '09d5ccbb-b01f-47a8-a023-693dade9611f', 'Yallo Abandoned Baskets - 2022-10 (October)', false, null ),
	( null, null, '54b013e4-21a3-4ad8-8674-ffadd0344f78', '09d5ccbb-b01f-47a8-a023-693dade9611f', 'Yallo Abandoned Baskets - 2022-10 (October)', false, null ),
	( null, null, '6d8a8503-cd9b-49f1-bc65-b5679242865e', '09d5ccbb-b01f-47a8-a023-693dade9611f', 'Yallo Abandoned Baskets - 2022-10 (October)', false, null ),
	( null, null, '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', 'Yallo Abandoned Baskets - 2022-11 (November)', false, null ),
	( null, null, 'a2774731-b2e7-4c07-9ddb-9b667d4a7247', '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', 'Yallo Abandoned Baskets - 2022-11 (November)', false, 'ok' ),
	( null, null, '8f0c0d94-e96c-4377-8693-93e52d62cdf0', '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', 'Yallo Abandoned Baskets - 2022-11 (November)', false, null ),
	( null, null, '8fec054e-d6ea-4361-8ea8-ab0d1e4227ac', '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', 'Yallo Abandoned Baskets - 2022-11 (November)', false, 'Assuming not yet used' ),
	( null, null, '351992c9-6d04-4f75-adb1-71deb017bfed', '54a5ba46-93e7-46b1-8135-a2a3cc5f3675', 'Yallo Abandoned Baskets - 2022-11 (November)', false, 'Assuming not yet used' ),
	( null, null, 'f20b0ea3-e44e-4017-8b18-113cb1828406', 'f20b0ea3-e44e-4017-8b18-113cb1828406', 'Yallo SITU - 2022-04 (April)', false, null ),
	( null, null, '672ce4ab-261d-440f-b19c-7dca8959d6fe', 'f20b0ea3-e44e-4017-8b18-113cb1828406', 'Yallo SITU - 2022-04 (April)', false, null ),
	( null, null, '1578ce21-519e-4f0c-81ac-4883968f5bf5', 'f20b0ea3-e44e-4017-8b18-113cb1828406', 'Yallo SITU - 2022-04 (April)', false, null ),
	( null, null, '1626738d-e41b-4ab8-9a7a-f56ba2f4f712', 'f20b0ea3-e44e-4017-8b18-113cb1828406', 'Yallo SITU - 2022-04 (April)', false, 'Looks like a real file, was it used?' ),
	( null, 'Abandoned Baskets', '89cc1efe-c34f-47df-af56-4214d94bcb89', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, 'Looks like a real file, was it used?' ),
	( null, 'Abandoned Baskets', 'fe7a0ac3-23ab-4d68-a0a9-c500acce4e12', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, 'Abandoned Baskets', '1e21791b-a862-4927-b04c-5e1f617974d1', 'e95f65b2-511e-4c48-9d64-56c9cd2c3db7', 'Yallo Abandoned Baskets - 2022-07 (July)', false, null ),
	( null, null, '0f84943c-ea41-46fd-91ad-6c35305052bf', '0f84943c-ea41-46fd-91ad-6c35305052bf', 'Yallo SITU - 2022-09 (September)', false, null ),
	( null, null, 'a88afc2a-7ae3-4422-8c2a-3a1555e293c1', 'a88afc2a-7ae3-4422-8c2a-3a1555e293c1', 'Yallo MBB - 2022-08 (August)', false, null ),
	( null, null, '83441817-ddc6-47ef-adf3-3109205d3450', 'a88afc2a-7ae3-4422-8c2a-3a1555e293c1', 'Yallo MBB - 2022-08 (August)', false, null ),
	( null, null, 'a06d1c1f-c83c-4dff-a6ed-422c8d94d1ad', 'a06d1c1f-c83c-4dff-a6ed-422c8d94d1ad', 'Yallo MBB - 2022-10 (October)', false, null ),
	( null, null, '44ef259c-33d9-4ee2-9009-7e7babca8020', '44ef259c-33d9-4ee2-9009-7e7babca8020', 'Yallo MBB - 2022-11 (November)', false, null ),
	( null, null, '6b5d4b84-4fba-4ae9-a484-aa3fa200dada', '44ef259c-33d9-4ee2-9009-7e7babca8020', 'Yallo MBB - 2022-11 (November)', false, null ),
	( null, null, 'c4e4a5d2-2d2b-4a54-b87e-5d82bb62e9e2', '44ef259c-33d9-4ee2-9009-7e7babca8020', 'Yallo MBB - 2022-11 (November)', false, null ),
	( null, null, '8644eefb-cff8-4c17-8dd7-e973444d38b6', '8644eefb-cff8-4c17-8dd7-e973444d38b6', 'Yallo Prepaid - 2022-05 (May)', false, null ),
	( null, null, '52b61b90-c68a-4c98-bdb0-853fa2b4256e', '52b61b90-c68a-4c98-bdb0-853fa2b4256e', 'Yallo Prepaid - 2022-09 (September)', false, null ),
	( null, null, '212c9727-262c-4acb-aa5d-7bd0ce70f016', '212c9727-262c-4acb-aa5d-7bd0ce70f016', 'Yallo Prepaid - 2022-10 (October)', false, null ),
	( null, null, '8de850d3-0446-4fd3-89c5-03a9f8e2d784', '212c9727-262c-4acb-aa5d-7bd0ce70f016', 'Yallo Prepaid - 2022-10 (October)', false, null ),
	( null, null, '38ef0a12-a038-485b-9d73-785403ded008', '212c9727-262c-4acb-aa5d-7bd0ce70f016', 'Yallo Prepaid - 2022-10 (October)', false, null ),
	( null, null, '5e34bef4-2c13-4c10-9576-6aa6da21440b', '212c9727-262c-4acb-aa5d-7bd0ce70f016', 'Yallo Prepaid - 2022-10 (October)', false, null ),
	( null, null, 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '80a5a06d-8d2b-4c7f-aa80-0efb70813ae8', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '776215e0-5cab-4b06-becc-a3f8e03ce73d', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '9a1f9d4f-ebbd-48fc-a110-19188c71d158', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '17cce345-a579-45f6-aeb1-aea30e74a23a', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '263c5597-f893-46f3-913a-aaab1c376a4a', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '5b20691a-7d61-4857-b668-cbbe7de3358a', 'b2be9563-01df-449d-ace2-2ba7b0c798fd', 'Yallo Prepaid - 2022-10 (November)', false, null ),
	( null, null, '5a084fb0-cb72-4244-a5a4-68172299ab14', '5a084fb0-cb72-4244-a5a4-68172299ab14', 'Yallo Fiber - 2022-07 (July)', false, null ),
	( null, null, '2f3d9573-696b-4c81-b270-0eddf77695fe', '2f3d9573-696b-4c81-b270-0eddf77695fe', 'Yallo Fiber - 2022-08 (August)', false, null ),
	( null, null, '4cb77ea3-e5fc-4cec-a049-3d1e845afeeb', '2f3d9573-696b-4c81-b270-0eddf77695fe', 'Yallo Fiber - 2022-08 (August)', false, null ),
	( null, null, '2e96f1b0-d347-459f-a081-b82e12291433', '2f3d9573-696b-4c81-b270-0eddf77695fe', 'Yallo Fiber - 2022-08 (August)', false, null ),
	( null, null, 'af531458-7468-482f-b144-3d78509c0635', 'af531458-7468-482f-b144-3d78509c0635', 'Yallo Fiber - 2022-09 (September)', false, 'Check month' ),
	( null, null, '52f975ee-79eb-40c4-b32e-c2bf72bdd0b3', '52f975ee-79eb-40c4-b32e-c2bf72bdd0b3', 'Yallo Fiber - 2022-06 (June)', false, null ),
	( null, null, 'ef2c4856-ff25-46a4-8430-9ec4f8804d1e', 'af531458-7468-482f-b144-3d78509c0635', 'Yallo Fiber - 2022-09 (September)', false, null ),
	( null, null, '6fb8d4f5-e5c8-4cfd-beb1-97f2079505c0', 'af531458-7468-482f-b144-3d78509c0635', 'Yallo Fiber - 2022-09 (September)', false, null ),
	( null, null, '91281e47-2365-4537-b63b-a652698bcbed', '91281e47-2365-4537-b63b-a652698bcbed', 'Yallo Fiber - 2022-09 (September) - Recycled', false, null ),
	( null, null, '4c6502ca-3637-4986-b0f2-584149b22b5f', '5a084fb0-cb72-4244-a5a4-68172299ab14', 'Yallo Fiber - 2022-07 (July)', false, null ),
	( null, null, 'ebcb8876-e984-4eea-a724-999f96e542af', 'ebcb8876-e984-4eea-a724-999f96e542af', 'Yallo Fiber - 2022-10 (October)', false, null ),
	( null, null, '71e8b078-e161-4397-a555-0832b09a66d8', 'ebcb8876-e984-4eea-a724-999f96e542af', 'Yallo Fiber - 2022-10 (October)', false, null ),
	( null, null, '406cec50-c2d1-4bea-8955-86efd92caef7', 'ebcb8876-e984-4eea-a724-999f96e542af', 'Yallo Fiber - 2022-10 (October)', false, null ),
	( null, null, 'fc582cdb-55ea-456f-add5-3a9da1f48e47', 'fc582cdb-55ea-456f-add5-3a9da1f48e47', 'Yallo Fiber - 2022-11 (November)', false, null ),
	( null, 'MNP/Churn', 'd151de3a-2b3a-4def-8f3b-3422da6d96ba', 'b88e273c-6d50-436a-b9eb-0a10653ac297', 'Yallo MNP - 2022-07 (July)', false, null ),
	( null, null, '60c74917-b59d-445a-9e1a-1b1b8a1363f6', '60c74917-b59d-445a-9e1a-1b1b8a1363f6', 'Yallo Chat - 2022-07 (July)', false, 'Why was this file never used???' ),
	( null, null, '51ead986-e5a6-4d72-9413-0e65112fabc6', '51ead986-e5a6-4d72-9413-0e65112fabc6', 'Yallo Chat - 2022-09 (September)', false, null ),
	( 'LEGACY', null, '1fb738b8-f795-42be-84a8-3110ae73a0ed', null, null, true, null ),
	( 'LEGACY', null, '5c99cfc6-3c01-4edf-9311-05201ab2db60', null, null, true, null ),
	( 'LEGACY', null, '767fc53b-a4cb-44d4-b87f-10791823fca2', null, null, true, null ),
	( 'LEGACY', null, '9e2ec4ff-186d-41f1-a656-75cea9647e64', null, null, true, null ),
	( 'LEGACY', null, '79003003-6e84-4e13-990a-96e89b0b43ed', null, null, true, null ),
	( 'LEGACY', null, 'bcd13e91-22eb-498a-98d5-0b18b3d2b874', null, null, true, null ),
	( 'LEGACY', null, '258209d5-cc4e-407b-8884-9237e91e0fd9', null, null, true, null ),
	( 'LEGACY', null, 'f5a78e8b-9d71-4efc-9793-036b8b437c57', null, null, true, null ),
	( 'LEGACY', null, '2de0615a-8f0a-4ebb-9663-99ec4a0281e5', null, null, true, null ),
	( 'LEGACY', null, 'bbb2d3d1-ed9e-457b-a0b8-55d942bdc303', null, null, true, null ),
	( 'LEGACY', null, 'db50f69f-752d-41b7-b8e4-f3dfe17b93dc', null, null, true, null ),
	( 'LEGACY', null, '762f26b3-47d6-4703-af74-9674aad1c491', null, null, true, null ),
	( 'LEGACY', null, '0c51bbeb-125b-4383-b4cc-81f1f4aa8e5c', null, null, true, null ),
	( 'LEGACY', null, '926af925-c306-496a-8724-e7a9216110c9', null, null, true, null ),
	( 'LEGACY', null, 'ac088e5d-e8d0-4864-9d11-811ad399b1c5', null, null, true, null ),
	( 'LEGACY', null, '738c8ede-4118-412d-891e-cf0933148cdf', null, null, true, null ),
	( 'LEGACY', null, 'e36c0837-cf35-448c-ad47-5df91c00dcaa', null, null, true, null ),
	( 'LEGACY', null, 'e96751d7-1365-485a-96bf-ec472683f882', null, null, true, null ),
	( 'LEGACY', null, '6c2dfe75-3ec9-46c9-a0ea-63a8734e053c', null, null, true, null ),
	( 'LEGACY', null, 'aa258f92-f2fa-40c9-9504-8ce4c8df6aa1', null, null, true, null )
;

-- select * from dashboards.migration_files_mapping;


-- --------------------------------------------------------------------------------
-- Campaign Mapping
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_campaign_mapping cascade;
create or replace function dashboards.utils_campaign_mapping(_campaign_id_ text, _campaign_name_ text) returns varchar(256) as $$
	select 
		case 
			when _campaign_name_ ilike '%Contest%' then 'Contest'
			when _campaign_name_ ilike '%test%' then '!!! TEST'
			when _campaign_name_ ilike '%MNP%' then 'MNP/Churn'
			when _campaign_name_ ilike '%Churn%' then 'MNP/Churn'
			when _campaign_name_ ilike '%Mobile anbiete%' then 'X-Sell Mobile (Internet only)'
			when _campaign_name_ ilike '%Prepaid%Fiber%' then 'Up-Sell Mobile (Prepaid with Fiber)'
			when _campaign_name_ ilike '%Schmidt%' then 'Fixed Net (Fiber)'
			when _campaign_name_ ilike '%Fiber%' then 'Fixed Net (Fiber)'
			when _campaign_name_ ilike '%Cable%' then 'Fixed Net (Cable)'
			when _campaign_name_ ilike '%Gigabox%' then 'Fixed Net (5G GigaBox)'
			when _campaign_name_ ilike '%MBB%' then 'X-Sell MBB'
			when _campaign_name_ ilike '%Chat%' then 'Chat'
			when _campaign_name_ ilike '%Aband%' then 'Abandoned Baskets'
			when _campaign_name_ ilike '%Basket%' then 'Abandoned Baskets'
			when _campaign_name_ ilike '%Verpasse Anrufe%' then 'Abandoned Calls' 
			when _campaign_name_ ilike '%SITU%' then 'SITU'
			when _campaign_name_ ilike '%Sunrise Prepaid%' then 'Up-Sell Mobile (Prepaid Sunrise)'
			when _campaign_name_ ilike '%Coop Prepaid%' then 'Up-Sell Mobile (Prepaid Coop)'
			when _campaign_name_ ilike '%Prepaid%Postpaid%' then 'Up-Sell Mobile (Prepaid with Postpaid)'
			when _campaign_name_ ilike '%Prepa%' then 'Up-Sell Mobile (Prepaid)'
			when _campaign_name_ ilike '%Pre_%' then 'Up-Sell Mobile (Prepaid)'
			-- 
			when _campaign_name_ ilike 'Content Tu_%' then '!!! TEST'
			when _campaign_name_ ilike 'Lead Titel' then '!!! TEST' -- or 'After Sales' ???
			when _campaign_name_ ilike 'Comxpert' then '!!! TEST'
			when _campaign_name_ ilike 'xxxx' then '!!! TEST'
			-- 
			else 'Other: ' || _campaign_name_ end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Cost & Call Durations/Types
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type_id cascade;
create or replace function dashboards.utils_call_type_id(_duration_ numeric) returns int as $$
	select 
		case 
			when _duration_ <= 15 +   0 then 0
			when _duration_ <= 15 +  20 then 1
			when _duration_ <= 15 + 300 then 2
			else 3 end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type_by_id cascade;
create or replace function dashboards.utils_call_type_by_id(_id_ numeric) returns varchar(128) as $$
	select 
		case 
			when _id_ = 0 then '0. Contact Attempt (not connected)'
			when _id_ = 1 then '1. Contact Handled (<20 seconds)'
			when _id_ = 2 then '2. Contact Argumented (>20 seconds)'
			when _id_ = 3 then '3. Contact Engaged (>5 minutes)' 
			when _id_ = 4 then '4. Contact Converted' 
			else '9. Error' end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_call_type cascade;
create or replace function dashboards.utils_call_type(_duration_ numeric) returns varchar(128) as $$
	select dashboards.utils_call_type_by_id(dashboards.utils_call_type_id(_duration_))
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_duration_minutes cascade;
create or replace function dashboards.utils_duration_minutes(_duration_ numeric) returns int as $$
	select case 
		when _duration_ <= 0 then 0
		else (1 + floor((_duration_ - 1.0) / 60.0)) end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cost_per_minute cascade;
create or replace function dashboards.utils_cost_per_minute(_duration_ numeric, _cost_ numeric) returns numeric as $$
	select case 
		when _duration_ <= 0 then _cost_
		else round(_cost_ / dashboards.utils_duration_minutes(_duration_), 2) end
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cost_category cascade;
create or replace function dashboards.utils_cost_category(_duration_ numeric, _cost_ numeric) returns varchar(128) as $$
	select 
		case 
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.15 then '0. Low [0.00..0.15]'
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.20 then '1. Medium [0.15..0.20]'
			when dashboards.utils_cost_per_minute(_duration_, _cost_) <= 0.30 then '2. High [0.20..0.30]'
			else '3. Very High [0.30...]' end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Agents
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_user_role cascade;
create or replace function dashboards.utils_user_role(_role_ int) returns varchar(128) as $$
	select 
		case 
			when _role_ = 0 then '0. Admin'
			when _role_ = 1 then '1. Organization'
			when _role_ = 2 then '2. Brand'
			when _role_ = 3 then '3. Site/Partner'
			when _role_ = 4 then '4. Team'
			when _role_ = 5 then '5. Agent'
			else '9. Unknown' end
$$ language sql;



-- --------------------------------------------------------------------------------
-- Dates & Times
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_hour cascade;
create or replace function dashboards.utils_format_hour(_date_ timestamp) returns char(2) as $$
	select to_char(_date_, 'HH24');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_day_of_week cascade;
create or replace function dashboards.utils_format_day_of_week(_date_ timestamp) returns char(12) as $$
	select to_char(_date_, 'ID. Day');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_date cascade;
create or replace function dashboards.utils_format_date(_date_ timestamp) returns char(10) as $$
	select to_char(_date_, 'YYYY-MM-DD');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_week cascade;
create or replace function dashboards.utils_format_week(_date_ timestamp) returns char(7) as $$
	select to_char(_date_, 'IYYY-IW');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_month cascade;
create or replace function dashboards.utils_format_month(_date_ timestamp) returns char(7) as $$
	select to_char(_date_, 'YYYY-MM');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_year cascade;
create or replace function dashboards.utils_format_year(_date_ timestamp) returns char(4) as $$
	select to_char(_date_, 'YYYY');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_year_ISO cascade;
create or replace function dashboards.utils_format_year_ISO(_date_ timestamp) returns char(4) as $$
	select to_char(_date_, 'IYYY');
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_cutoff_date cascade;
create or replace function dashboards.utils_cutoff_date(_field_ text, _limited_ boolean) returns timestamp as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select case 
		when not _limited_ then null
		when _field_ in ('year', 'month') then date_trunc('month', current_date - interval '13 months')
		when _field_ = 'week' then date_trunc('week', current_date - interval '14 weeks')
		when _field_ in ('day', 'day_of_week') then date_trunc('day', current_date - interval '33 days')
		when _field_ = 'hour' then date_trunc('day', current_date - interval '9 days')
		when _field_ = 'last 3 months' then date_trunc('day', current_date - interval '91 days')
		when _field_ = 'last 6 weeks' then date_trunc('day', current_date - interval '42 days')
		when _field_ = 'last 3 weeks' then date_trunc('day', current_date - interval '21 days')
		else null end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_timestamp_with_cutoff cascade;
create or replace function dashboards.utils_format_timestamp_with_cutoff(_date_ timestamp, _field_ text, _interval_ text, _cutoff_ timestamp) returns varchar(64) as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select case 
		when _cutoff_ is not null and _date_ < _cutoff_ then null
		when _interval_ is not null and _field_ <> 'custom' and _interval_ <> _field_ then null
		when _field_ = 'year' and _interval_ = 'week' then dashboards.utils_format_year_ISO(_date_)
		when _field_ = 'year' then dashboards.utils_format_year(_date_)
		when _field_ = 'month' then dashboards.utils_format_month(_date_)
		when _field_ = 'week' then dashboards.utils_format_week(_date_)
		when _field_ = 'day' then dashboards.utils_format_date(_date_)
		when _field_ = 'day_of_week' then dashboards.utils_format_day_of_week(_date_)
		when _field_ = 'hour' then dashboards.utils_format_hour(_date_)
		else _interval_ end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_format_timestamp cascade;
create or replace function dashboards.utils_format_timestamp(_date_ timestamp, _field_ text, _interval_ text, _limited_ boolean) returns varchar(64) as $$ -- if "interval" is set, then it assumes strict aggregation on this interval and will ignore incompatible "fields"
	select dashboards.utils_format_timestamp_with_cutoff(_date_, _field_, _interval_, dashboards.utils_cutoff_date(_field_, _limited_));
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_time_difference cascade;
create or replace function dashboards.utils_time_difference(_date1_ timestamp, _date2_ timestamp) returns int as $$ -- Returns the time difference in seconds
	select extract(epoch from (_date2_ - _date1_));
$$ language sql;



-- --------------------------------------------------------------------------------
-- Miscellaneous Utilities
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_division cascade;
create or replace function dashboards.utils_division(_numerator_ numeric, _denominator_ numeric) returns numeric as $$ -- Returns the time difference in seconds
	select case
		when coalesce(_denominator_, 0.0) = 0.0 then null
		else _numerator_ / _denominator_ end;
$$ language sql;

-- --------------------------------------------------------------------------------
-- drop function if exists dashboards.utils_ratio cascade;
create or replace function dashboards.utils_ratio(_numerator_ numeric, _denominator_ numeric, _precision_ int) returns numeric as $$ -- Returns the time difference in seconds
	select case
		when coalesce(_denominator_, 0.0) = 0.0 then null
		else round(_numerator_ / _denominator_, _precision_) end;
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_percent cascade;
create or replace function dashboards.utils_percent(_numerator_ numeric, _denominator_ numeric, _precision_ int) returns numeric as $$ -- Returns the time difference in seconds
	select dashboards.utils_ratio(100.0 * _numerator_, _denominator_, _precision_);
$$ language sql;

-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_generate_uuid cascade;
create or replace function dashboards.utils_generate_uuid(_text_ text) returns varchar(36) as $$
declare
	_md5_ char(32) := md5(_text_);
begin
	return substring(_md5_, 1, 8) || '-' || substring(_md5_, 5, 4) || '-' || substring(_md5_, 9, 4) || '-' || substring(_md5_, 13, 4) || '-' || substring(_md5_, 17);
end;
$$ language plpgsql;



-- --------------------------------------------------------------------------------
-- Data normalization
-- --------------------------------------------------------------------------------

-- drop function if exists dashboards.utils_household_key cascade;
create or replace function dashboards.utils_household_key(zip text, street text, street_number text, last_name text) returns varchar(1024) as $$
	select
	case 
		when coalesce(zip, '') = '' or coalesce(street, '') = '' or coalesce(last_name, '') = '' then null
		else
			concat(
				lower(trim(zip)),
				'|',
				lower(trim(street)),
				'|',
				lower(trim(coalesce(street_number, '-'))),
				'|',
				substring(trim(lower(last_name)), 1, 4),
				regexp_replace(trim(lower(last_name)), ' .*', '') -- 1st for letters, and what is after until first space (to avoid multiple names)
-- MySQL:		trim(lower(substring(last_name, 1, 4))), lower(substring_index(substring(last_name, 5), ' ', 1)) -- 1st for letters, and what is after until first space (to avoid multiple names)
--				case when length(substring_index(last_name, ' ', 1)) <= 3 then lower(trim(last_name)) else lower(trim(substring_index(last_name, ' ', 1))) end
			) 
		end;
$$ language sql;

-- --------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------
-- ...
-- --------------------------------------------------------------------------------




