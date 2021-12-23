SET DATEFIRST 1
DECLARE @Year [int] = {@Year}

DECLARE @BeginDate [date] = DATEFROMPARTS(@Year, 1, 1)
DECLARE @EndDate [date] = DATEFROMPARTS(@Year, 12, 31)

BEGIN
	DECLARE @Number TABLE
	(
		[Number] [int] NOT NULL,
		[Ordinal] [varchar](100) NOT NULL,
		[Words] [varchar](100) NOT NULL
	);
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (1, '1st', 'First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (2, '2nd', 'Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (3, '3rd', 'Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (4, '4th', 'Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (5, '5th', 'Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (6, '6th', 'Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (7, '7th', 'Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (8, '8th', 'Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (9, '9th', 'Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (10, '10th', 'Tenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (11, '11th', 'Eleventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (12, '12th', 'Twelfth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (13, '13th', 'Thirteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (14, '14th', 'Fourteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (15, '15th', 'Fifteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (16, '16th', 'Sixteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (17, '17th', 'Seventeenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (18, '18th', 'Eighteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (19, '19th', 'Nineteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (20, '20th', 'Twenty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (21, '21st', 'Twenty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (22, '22nd', 'Twenty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (23, '23rd', 'Twenty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (24, '24th', 'Twenty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (25, '25th', 'Twenty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (26, '26th', 'Twenty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (27, '27th', 'Twenty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (28, '28th', 'Twenty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (29, '29th', 'Twenty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (30, '30th', 'Thirty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (31, '31st', 'Thirty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (32, '32nd', 'Thirty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (33, '33rd', 'Thirty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (34, '34th', 'Thirty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (35, '35th', 'Thirty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (36, '36th', 'Thirty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (37, '37th', 'Thirty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (38, '38th', 'Thirty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (39, '39th', 'Thirty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (40, '40th', 'Forty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (41, '41st', 'Forty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (42, '42nd', 'Forty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (43, '43rd', 'Forty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (44, '44th', 'Forty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (45, '45th', 'Forty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (46, '46th', 'Forty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (47, '47th', 'Forty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (48, '48th', 'Forty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (49, '49th', 'Forty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (50, '50th', 'Fifty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (51, '51st', 'Fifty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (52, '52nd', 'Fifty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (53, '53rd', 'Fifty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (54, '54th', 'Fifty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (55, '55th', 'Fifty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (56, '56th', 'Fifty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (57, '57th', 'Fifty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (58, '58th', 'Fifty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (59, '59th', 'Fifty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (60, '60th', 'Sixty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (61, '61st', 'Sixty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (62, '62nd', 'Sixty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (63, '63rd', 'Sixty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (64, '64th', 'Sixty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (65, '65th', 'Sixty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (66, '66th', 'Sixty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (67, '67th', 'Sixty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (68, '68th', 'Sixty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (69, '69th', 'Sixty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (70, '70th', 'Seventy-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (71, '71st', 'Seventy-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (72, '72nd', 'Seventy-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (73, '73rd', 'Seventy-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (74, '74th', 'Seventy-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (75, '75th', 'Seventy-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (76, '76th', 'Seventy-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (77, '77th', 'Seventy-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (78, '78th', 'Seventy-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (79, '79th', 'Seventy-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (80, '80th', 'Eighty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (81, '81st', 'Eighty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (82, '82nd', 'Eighty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (83, '83rd', 'Eighty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (84, '84th', 'Eighty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (85, '85th', 'Eighty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (86, '86th', 'Eighty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (87, '87th', 'Eighty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (88, '88th', 'Eighty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (89, '89th', 'Eighty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (90, '90th', 'Ninety-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (91, '91st', 'Ninety-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (92, '92nd', 'Ninety-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (93, '93rd', 'Ninety-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (94, '94th', 'Ninety-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (95, '95th', 'Ninety-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (96, '96th', 'Ninety-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (97, '97th', 'Ninety-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (98, '98th', 'Ninety-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (99, '99th', 'Ninety-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (100, '100th', 'One Hundred');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (101, '101st', 'One Hundred First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (102, '102nd', 'One Hundred Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (103, '103rd', 'One Hundred Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (104, '104th', 'One Hundred Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (105, '105th', 'One Hundred Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (106, '106th', 'One Hundred Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (107, '107th', 'One Hundred Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (108, '108th', 'One Hundred Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (109, '109th', 'One Hundred Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (110, '110th', 'One Hundred Tenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (111, '111st', 'One Hundred Eleventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (112, '112nd', 'One Hundred Twelfth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (113, '113rd', 'One Hundred Thirteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (114, '114th', 'One Hundred Fourteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (115, '115th', 'One Hundred Fifteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (116, '116th', 'One Hundred Sixteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (117, '117th', 'One Hundred Seventeenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (118, '118th', 'One Hundred Eighteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (119, '119th', 'One Hundred Nineteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (120, '120th', 'One Hundred Twenty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (121, '121st', 'One Hundred Twenty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (122, '122nd', 'One Hundred Twenty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (123, '123rd', 'One Hundred Twenty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (124, '124th', 'One Hundred Twenty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (125, '125th', 'One Hundred Twenty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (126, '126th', 'One Hundred Twenty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (127, '127th', 'One Hundred Twenty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (128, '128th', 'One Hundred Twenty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (129, '129th', 'One Hundred Twenty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (130, '130th', 'One Hundred Thirty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (131, '131st', 'One Hundred Thirty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (132, '132nd', 'One Hundred Thirty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (133, '133rd', 'One Hundred Thirty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (134, '134th', 'One Hundred Thirty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (135, '135th', 'One Hundred Thirty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (136, '136th', 'One Hundred Thirty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (137, '137th', 'One Hundred Thirty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (138, '138th', 'One Hundred Thirty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (139, '139th', 'One Hundred Thirty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (140, '140th', 'One Hundred Forty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (141, '141st', 'One Hundred Forty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (142, '142nd', 'One Hundred Forty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (143, '143rd', 'One Hundred Forty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (144, '144th', 'One Hundred Forty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (145, '145th', 'One Hundred Forty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (146, '146th', 'One Hundred Forty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (147, '147th', 'One Hundred Forty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (148, '148th', 'One Hundred Forty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (149, '149th', 'One Hundred Forty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (150, '150th', 'One Hundred Fifty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (151, '151st', 'One Hundred Fifty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (152, '152nd', 'One Hundred Fifty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (153, '153rd', 'One Hundred Fifty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (154, '154th', 'One Hundred Fifty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (155, '155th', 'One Hundred Fifty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (156, '156th', 'One Hundred Fifty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (157, '157th', 'One Hundred Fifty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (158, '158th', 'One Hundred Fifty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (159, '159th', 'One Hundred Fifty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (160, '160th', 'One Hundred Sixty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (161, '161st', 'One Hundred Sixty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (162, '162nd', 'One Hundred Sixty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (163, '163rd', 'One Hundred Sixty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (164, '164th', 'One Hundred Sixty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (165, '165th', 'One Hundred Sixty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (166, '166th', 'One Hundred Sixty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (167, '167th', 'One Hundred Sixty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (168, '168th', 'One Hundred Sixty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (169, '169th', 'One Hundred Sixty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (170, '170th', 'One Hundred Seventy-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (171, '171st', 'One Hundred Seventy-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (172, '172nd', 'One Hundred Seventy-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (173, '173rd', 'One Hundred Seventy-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (174, '174th', 'One Hundred Seventy-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (175, '175th', 'One Hundred Seventy-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (176, '176th', 'One Hundred Seventy-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (177, '177th', 'One Hundred Seventy-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (178, '178th', 'One Hundred Seventy-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (179, '179th', 'One Hundred Seventy-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (180, '180th', 'One Hundred Eighty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (181, '181st', 'One Hundred Eighty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (182, '182nd', 'One Hundred Eighty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (183, '183rd', 'One Hundred Eighty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (184, '184th', 'One Hundred Eighty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (185, '185th', 'One Hundred Eighty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (186, '186th', 'One Hundred Eighty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (187, '187th', 'One Hundred Eighty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (188, '188th', 'One Hundred Eighty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (189, '189th', 'One Hundred Eighty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (190, '190th', 'One Hundred Ninety-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (191, '191st', 'One Hundred Ninety-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (192, '192nd', 'One Hundred Ninety-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (193, '193rd', 'One Hundred Ninety-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (194, '194th', 'One Hundred Ninety-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (195, '195th', 'One Hundred Ninety-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (196, '196th', 'One Hundred Ninety-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (197, '197th', 'One Hundred Ninety-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (198, '198th', 'One Hundred Ninety-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (199, '199th', 'One Hundred Ninety-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (200, '200th', 'Two Hundred');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (201, '201st', 'Two Hundred First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (202, '202nd', 'Two Hundred Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (203, '203rd', 'Two Hundred Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (204, '204th', 'Two Hundred Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (205, '205th', 'Two Hundred Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (206, '206th', 'Two Hundred Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (207, '207th', 'Two Hundred Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (208, '208th', 'Two Hundred Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (209, '209th', 'Two Hundred Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (210, '210th', 'Two Hundred Tenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (211, '211st', 'Two Hundred Eleventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (212, '212nd', 'Two Hundred Twelfth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (213, '213rd', 'Two Hundred Thirteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (214, '214th', 'Two Hundred Fourteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (215, '215th', 'Two Hundred Fifteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (216, '216th', 'Two Hundred Sixteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (217, '217th', 'Two Hundred Seventeenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (218, '218th', 'Two Hundred Eighteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (219, '219th', 'Two Hundred Nineteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (220, '220th', 'Two Hundred Twenty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (221, '221st', 'Two Hundred Twenty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (222, '222nd', 'Two Hundred Twenty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (223, '223rd', 'Two Hundred Twenty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (224, '224th', 'Two Hundred Twenty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (225, '225th', 'Two Hundred Twenty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (226, '226th', 'Two Hundred Twenty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (227, '227th', 'Two Hundred Twenty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (228, '228th', 'Two Hundred Twenty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (229, '229th', 'Two Hundred Twenty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (230, '230th', 'Two Hundred Thirty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (231, '231st', 'Two Hundred Thirty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (232, '232nd', 'Two Hundred Thirty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (233, '233rd', 'Two Hundred Thirty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (234, '234th', 'Two Hundred Thirty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (235, '235th', 'Two Hundred Thirty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (236, '236th', 'Two Hundred Thirty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (237, '237th', 'Two Hundred Thirty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (238, '238th', 'Two Hundred Thirty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (239, '239th', 'Two Hundred Thirty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (240, '240th', 'Two Hundred Forty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (241, '241st', 'Two Hundred Forty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (242, '242nd', 'Two Hundred Forty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (243, '243rd', 'Two Hundred Forty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (244, '244th', 'Two Hundred Forty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (245, '245th', 'Two Hundred Forty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (246, '246th', 'Two Hundred Forty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (247, '247th', 'Two Hundred Forty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (248, '248th', 'Two Hundred Forty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (249, '249th', 'Two Hundred Forty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (250, '250th', 'Two Hundred Fifty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (251, '251st', 'Two Hundred Fifty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (252, '252nd', 'Two Hundred Fifty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (253, '253rd', 'Two Hundred Fifty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (254, '254th', 'Two Hundred Fifty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (255, '255th', 'Two Hundred Fifty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (256, '256th', 'Two Hundred Fifty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (257, '257th', 'Two Hundred Fifty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (258, '258th', 'Two Hundred Fifty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (259, '259th', 'Two Hundred Fifty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (260, '260th', 'Two Hundred Sixty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (261, '261st', 'Two Hundred Sixty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (262, '262nd', 'Two Hundred Sixty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (263, '263rd', 'Two Hundred Sixty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (264, '264th', 'Two Hundred Sixty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (265, '265th', 'Two Hundred Sixty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (266, '266th', 'Two Hundred Sixty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (267, '267th', 'Two Hundred Sixty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (268, '268th', 'Two Hundred Sixty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (269, '269th', 'Two Hundred Sixty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (270, '270th', 'Two Hundred Seventy-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (271, '271st', 'Two Hundred Seventy-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (272, '272nd', 'Two Hundred Seventy-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (273, '273rd', 'Two Hundred Seventy-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (274, '274th', 'Two Hundred Seventy-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (275, '275th', 'Two Hundred Seventy-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (276, '276th', 'Two Hundred Seventy-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (277, '277th', 'Two Hundred Seventy-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (278, '278th', 'Two Hundred Seventy-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (279, '279th', 'Two Hundred Seventy-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (280, '280th', 'Two Hundred Eighty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (281, '281st', 'Two Hundred Eighty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (282, '282nd', 'Two Hundred Eighty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (283, '283rd', 'Two Hundred Eighty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (284, '284th', 'Two Hundred Eighty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (285, '285th', 'Two Hundred Eighty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (286, '286th', 'Two Hundred Eighty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (287, '287th', 'Two Hundred Eighty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (288, '288th', 'Two Hundred Eighty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (289, '289th', 'Two Hundred Eighty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (290, '290th', 'Two Hundred Ninety-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (291, '291st', 'Two Hundred Ninety-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (292, '292nd', 'Two Hundred Ninety-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (293, '293rd', 'Two Hundred Ninety-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (294, '294th', 'Two Hundred Ninety-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (295, '295th', 'Two Hundred Ninety-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (296, '296th', 'Two Hundred Ninety-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (297, '297th', 'Two Hundred Ninety-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (298, '298th', 'Two Hundred Ninety-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (299, '299th', 'Two Hundred Ninety-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (300, '300th', 'Three Hundred');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (301, '301st', 'Three Hundred First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (302, '302nd', 'Three Hundred Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (303, '303rd', 'Three Hundred Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (304, '304th', 'Three Hundred Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (305, '305th', 'Three Hundred Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (306, '306th', 'Three Hundred Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (307, '307th', 'Three Hundred Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (308, '308th', 'Three Hundred Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (309, '309th', 'Three Hundred Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (310, '310th', 'Three Hundred Tenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (311, '311st', 'Three Hundred Eleventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (312, '312nd', 'Three Hundred Twelfth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (313, '313rd', 'Three Hundred Thirteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (314, '314th', 'Three Hundred Fourteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (315, '315th', 'Three Hundred Fifteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (316, '316th', 'Three Hundred Sixteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (317, '317th', 'Three Hundred Seventeenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (318, '318th', 'Three Hundred Eighteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (319, '319th', 'Three Hundred Nineteenth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (320, '320th', 'Three Hundred Twenty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (321, '321st', 'Three Hundred Twenty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (322, '322nd', 'Three Hundred Twenty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (323, '323rd', 'Three Hundred Twenty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (324, '324th', 'Three Hundred Twenty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (325, '325th', 'Three Hundred Twenty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (326, '326th', 'Three Hundred Twenty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (327, '327th', 'Three Hundred Twenty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (328, '328th', 'Three Hundred Twenty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (329, '329th', 'Three Hundred Twenty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (330, '330th', 'Three Hundred Thirty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (331, '331st', 'Three Hundred Thirty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (332, '332nd', 'Three Hundred Thirty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (333, '333rd', 'Three Hundred Thirty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (334, '334th', 'Three Hundred Thirty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (335, '335th', 'Three Hundred Thirty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (336, '336th', 'Three Hundred Thirty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (337, '337th', 'Three Hundred Thirty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (338, '338th', 'Three Hundred Thirty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (339, '339th', 'Three Hundred Thirty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (340, '340th', 'Three Hundred Forty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (341, '341st', 'Three Hundred Forty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (342, '342nd', 'Three Hundred Forty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (343, '343rd', 'Three Hundred Forty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (344, '344th', 'Three Hundred Forty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (345, '345th', 'Three Hundred Forty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (346, '346th', 'Three Hundred Forty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (347, '347th', 'Three Hundred Forty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (348, '348th', 'Three Hundred Forty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (349, '349th', 'Three Hundred Forty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (350, '350th', 'Three Hundred Fifty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (351, '351st', 'Three Hundred Fifty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (352, '352nd', 'Three Hundred Fifty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (353, '353rd', 'Three Hundred Fifty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (354, '354th', 'Three Hundred Fifty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (355, '355th', 'Three Hundred Fifty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (356, '356th', 'Three Hundred Fifty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (357, '357th', 'Three Hundred Fifty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (358, '358th', 'Three Hundred Fifty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (359, '359th', 'Three Hundred Fifty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (360, '360th', 'Three Hundred Sixty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (361, '361st', 'Three Hundred Sixty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (362, '362nd', 'Three Hundred Sixty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (363, '363rd', 'Three Hundred Sixty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (364, '364th', 'Three Hundred Sixty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (365, '365th', 'Three Hundred Sixty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (366, '366th', 'Three Hundred Sixty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (367, '367th', 'Three Hundred Sixty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (368, '368th', 'Three Hundred Sixty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (369, '369th', 'Three Hundred Sixty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (370, '370th', 'Three Hundred Seventy-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (371, '371st', 'Three Hundred Seventy-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (372, '372nd', 'Three Hundred Seventy-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (373, '373rd', 'Three Hundred Seventy-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (374, '374th', 'Three Hundred Seventy-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (375, '375th', 'Three Hundred Seventy-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (376, '376th', 'Three Hundred Seventy-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (377, '377th', 'Three Hundred Seventy-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (378, '378th', 'Three Hundred Seventy-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (379, '379th', 'Three Hundred Seventy-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (380, '380th', 'Three Hundred Eighty-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (381, '381st', 'Three Hundred Eighty-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (382, '382nd', 'Three Hundred Eighty-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (383, '383rd', 'Three Hundred Eighty-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (384, '384th', 'Three Hundred Eighty-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (385, '385th', 'Three Hundred Eighty-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (386, '386th', 'Three Hundred Eighty-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (387, '387th', 'Three Hundred Eighty-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (388, '388th', 'Three Hundred Eighty-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (389, '389th', 'Three Hundred Eighty-Nineth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (390, '390th', 'Three Hundred Ninety-');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (391, '391st', 'Three Hundred Ninety-First');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (392, '392nd', 'Three Hundred Ninety-Second');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (393, '393rd', 'Three Hundred Ninety-Third');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (394, '394th', 'Three Hundred Ninety-Forth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (395, '395th', 'Three Hundred Ninety-Fifth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (396, '396th', 'Three Hundred Ninety-Sixth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (397, '397th', 'Three Hundred Ninety-Seventh');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (398, '398th', 'Three Hundred Ninety-Eighth');
	INSERT INTO @Number ([Number], [Ordinal], [Words]) VALUES (399, '399th', 'Three Hundred Ninety-Nineth');
END


DECLARE @Date TABLE
(
	[Date] [date] NOT NULL
)
;WITH
	[Date]
	(
		[Date]
	)
	AS
	(
		SELECT
			[Date].[Date]
			FROM
			(
				SELECT @BeginDate AS [Date]
			) AS [Date]

		UNION ALL
		SELECT
			[Date].[Date]
			FROM
			(
				SELECT DATEADD([DAY], 1, [Date].[Date]) AS [Date]
					FROM [Date]
			) AS [Date]
			WHERE [Date].[Date] <= @EndDate
	)
	INSERT INTO @Date([Date])
		SELECT [Date].[Date]
			FROM [Date]
			ORDER BY [Date].[Date]
			OPTION (MAXRECURSION 32767)

	SELECT
		FORMAT(CONVERT([int], FORMAT([Date].[Date], 'yyyyMMdd'), 0), '0') AS [DateKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Century], 'yyyyMMdd'), 0), '0') AS [CenturyKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Year], 'yyyyMMdd'), 0), '0') AS [YearKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Semester], 'yyyyMMdd'), 0), '0') AS [SemesterKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Trimester], 'yyyyMMdd'), 0), '0') AS [TrimesterKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Quarter], 'yyyyMMdd'), 0), '0') AS [QuarterKey],
		FORMAT(CONVERT([int], FORMAT([Date].[Month], 'yyyyMMdd'), 0), '0') AS [MonthKey],
		FORMAT(CONVERT([int], FORMAT([Date].[ISOWeek], 'yyyyMMdd'), 0), '0') AS [ISOWeekKey],

		FORMAT([Date].[Date], 'yyyy-MM-dd') AS [Date],
		FORMAT([Date].[Century], 'yyyy-MM-dd') AS [Century],
		FORMAT([Date].[Year], 'yyyy-MM-dd') AS [Year],
		FORMAT([Date].[Semester], 'yyyy-MM-dd') AS [Semester],
		FORMAT([Date].[Trimester], 'yyyy-MM-dd') AS [Trimester],
		FORMAT([Date].[Quarter], 'yyyy-MM-dd') AS [Quarter],
		FORMAT([Date].[Month], 'yyyy-MM-dd') AS [Month],
		FORMAT([Date].[ISOWeek], 'yyyy-MM-dd') AS [ISOWeek],

		FORMAT(CONVERT([int], FORMAT([Date].[Date], 'yyyyMMdd'), 0), '0') AS [DateNumber],
		FORMAT([Date].[CenturyNumber], '0') AS [CenturyNumber],
		FORMAT(CONVERT([int], FORMAT([Date].[Year], 'yyyy'), 0), '0') AS [YearNumber],
		FORMAT([Date].[SemesterNumber], '0') AS [SemesterNumber],
		FORMAT([Date].[TrimesterNumber], '0') AS [TrimesterNumber],
		FORMAT([Date].[QuarterNumber], '0') AS [QuarterNumber],
		FORMAT(MONTH([Date].[Month]), '0') AS [MonthNumber],
		FORMAT([Date].[ISOWeekNumber], '0') AS [ISOWeekNumber],
		FORMAT(DATEPART([DAYOFYEAR], [Date].[Date]), '0') AS [DayOfYearNumber],
		FORMAT([Number_DayOfMonthNumber].[Number], '0') AS [DayOfMonthNumber],
		FORMAT([Date].[DayOfWeekMonthOccurrenceNumber], '0') AS [DayOfWeekMonthOccurrenceNumber],
		FORMAT(DATEPART([WEEKDAY], [Date].[Date]), '0') AS [DayOfWeekNumber],

		DATEDIFF_BIG([SECOND], '1970-01-01', [Date].[Date]) AS [UnixTimestamp],

		--Names and Labels
		FORMAT([Date].[Date], 'yyyy-MM-dd') AS [DateShortName],
		CONCAT
		(
			FORMAT([Date].[Date], 'MMMM d'),
			CASE
				WHEN DATEPART([DAY], [Date].[Date]) IN (11, 12, 13)
					THEN 'th'
				WHEN RIGHT(FORMAT([Date].[Date], '%d'), 1) = '1'
					THEN 'st'
				WHEN RIGHT(FORMAT([Date].[Date], '%d'), 1) = '2'
					THEN 'nd'
				WHEN RIGHT(FORMAT([Date].[Date], '%d'), 1) = '3'
					THEN 'rd'
				ELSE 'th'
			END,
			', ',
			FORMAT([Date].[Date], 'yyyy')
		) AS [DateLongName],
		UPPER(FORMAT([Date].[Date], 'dd MMM yyyy')) AS [DateMilitary],

		[Number_Century].[Words] AS [CenturyName],
		FORMAT([Date].[Year], 'yyyy-MM-dd') AS [YearName],
		[Number_Semester].[Words] AS [SemesterName],
		[Number_Trimester].[Words] AS [TrimesterName],
		[Number_Quarter].[Words] AS [QuarterName],
		FORMAT([Date].[Month], 'MMMM') AS [MonthName],
		FORMAT(DATEPART([DAYOFYEAR], [Date].[Date]), '000') AS [DayOfYearName],
		[Number_DayOfMonthNumber].[Ordinal] AS [DayOfMonthName],
		CONCAT([Number_MonthOccurrence].[Words], ' ', FORMAT([Date].[Date], 'dddd')) AS [DayOfWeekMonthOccurrenceName],
		FORMAT([Date].[Date], 'dddd') AS [DayOfWeekName],

		CONCAT('S', FORMAT([Date].[SemesterNumber], '0'))  AS [SemesterAbbreviated],
		CONCAT('T', FORMAT([Date].[SemesterNumber], '0'))  AS [TrimesterAbbreviated],
		CONCAT('Q', FORMAT([Date].[QuarterNumber], '0'))  AS [QuarterAbbreviated],
		FORMAT([Date].[Month], 'MMM') AS [MonthAbbreviation],
		CONCAT([Number_MonthOccurrence].[Ordinal], ' ', FORMAT([Date].[Date], 'ddd')) AS [DayOfWeekMonthOccurrenceAbbreviated],
		FORMAT([Date].[Date], 'ddd') AS [DayOfWeekAbbreviated],


		CONCAT(FORMAT([Date].[Quarter], 'yyyy'), '-S', FORMAT([Date].[SemesterNumber], '0'))  AS [YearSemesterAbbreviated],
		CONCAT(FORMAT([Date].[Quarter], 'yyyy'), '-T', FORMAT([Date].[SemesterNumber], '0'))  AS [YearTrimesterAbbreviated],
		CONCAT(FORMAT([Date].[Quarter], 'yyyy'), '-Q', FORMAT([Date].[QuarterNumber], '0'))  AS [YearQuarterAbbreviated],
		FORMAT([Date].[Month], 'yyyy-MM (MMM)') AS [YearMonthAbbreviation],
		CONCAT(FORMAT([Date].[Quarter], 'yyyy'), '-', FORMAT(DATEPART([DAYOFYEAR], [Date].[Date]), '000')) AS [YearDayOfYearAbbreviated],

		CONCAT
		(
			FORMAT([Date].[Semester], 'yyyy'),
			'-',
			[Number_Semester].[Words],
			' Semester'
		)  AS [YearSemesterName],
		CONCAT
		(
			FORMAT([Date].[Trimester], 'yyyy'),
			'-',
			[Number_Trimester].[Words],
			' Trimester'
		)  AS [YearTrimesterName],
		CONCAT
		(
			FORMAT([Date].[Quarter], 'yyyy'),
			'-',
			[Number_Quarter].[Words],
			' Quarter'
		)  AS [YearQuarterName],

		FORMAT([Date].[Month], 'yyyy-MM (MMMM)') AS [YearMonthName],

		CONCAT(FORMAT([Date].[ISOWeek], 'yyyy'), '-W', FORMAT([Date].[ISOWeekNumber], '00')) AS [ISOWeekName],
		CONCAT(FORMAT([Date].[ISOWeek], 'yyyy'), '-W-', FORMAT(DATEPART([WEEKDAY], [Date].[Date]), '0')) AS [ISOWeekDay],

		CASE
			WHEN FORMAT([Date].[Date], 'ddd') IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri')
				THEN 'Weekday'
			WHEN FORMAT([Date].[Date], 'ddd') IN ('Sat', 'Sun')
				THEN 'Weekend'
		END AS [WeekSegmentName]

		FROM
		(
			SELECT
				[Date].[Date],

				DATEFROMPARTS
				(
					CONVERT
					(
						[int],
						CONCAT
						(
							FORMAT(((YEAR([Date].[Date]) - 1) / 100), '00'),
							'01'
						),
						1
					),
					1,
					1
				) AS [Century],

				(1 + (YEAR([Date].[Date]) - 1) / 100) AS [CenturyNumber],


				DATEFROMPARTS(YEAR([Date].[Date]), 1, 1) AS [Year],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 6
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 7, 1)
				END AS [Semester],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 6
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 12
						THEN 2
				END AS [SemesterNumber],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 4
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 5 AND 8
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 5, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 9 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 9, 1)
				END AS [Trimester],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 4
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 5 AND 8
						THEN 2
					WHEN MONTH([Date].[Date]) BETWEEN 9 AND 12
						THEN 3
				END AS [TrimesterNumber],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 3
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 1, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 4 AND 6
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 4, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 9
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 6, 1)
					WHEN MONTH([Date].[Date]) BETWEEN 10 AND 12
						THEN DATEFROMPARTS(YEAR([Date].[Date]), 10, 1)
				END AS [Quarter],
				CASE
					WHEN MONTH([Date].[Date]) BETWEEN 1 AND 3
						THEN 1
					WHEN MONTH([Date].[Date]) BETWEEN 4 AND 6
						THEN 2
					WHEN MONTH([Date].[Date]) BETWEEN 7 AND 9
						THEN 3
					WHEN MONTH([Date].[Date]) BETWEEN 10 AND 12
						THEN 4
				END AS [QuarterNumber],
				DATEFROMPARTS(YEAR([Date].[Date]), MONTH([Date].[Date]), 1) AS [Month],

				CASE
					WHEN [Date].[Date] > '0001-01-06'
						THEN
							CASE DATEPART([ISO_WEEK], [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -6, [Date].[Date])) THEN DATEADD([DAY], -6, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -5, [Date].[Date])) THEN DATEADD([DAY], -5, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -4, [Date].[Date])) THEN DATEADD([DAY], -4, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -3, [Date].[Date])) THEN DATEADD([DAY], -3, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -2, [Date].[Date])) THEN DATEADD([DAY], -2, [Date].[Date])
								WHEN DATEPART([ISO_WEEK], DATEADD([DAY], -1, [Date].[Date])) THEN DATEADD([DAY], -1, [Date].[Date])
								ELSE DATEADD([DAY],  0, [Date].[Date])
							END
						ELSE '0001-01-01'
				END AS [ISOWeek],
				DATEPART([ISO_WEEK], [Date].[Date]) AS [ISOWeekNumber],
				(FLOOR((DAY([Date].[Date])-1) / 7) + 1) AS [DayOfWeekMonthOccurrenceNumber],
				DAY([Date].[Date]) AS [DayOfMonthNumber]
				FROM @Date AS [Date]
		) AS [Date]
			INNER JOIN @Number AS [Number_Century]
				ON [Date].[CenturyNumber] = [Number_Century].[Number]
			INNER JOIN @Number AS [Number_Semester]
				ON [Date].[SemesterNumber] = [Number_Semester].[Number]
			INNER JOIN @Number AS [Number_Trimester]
				ON [Date].[TrimesterNumber] = [Number_Trimester].[Number]
			INNER JOIN @Number AS [Number_Quarter]
				ON [Date].[QuarterNumber] = [Number_Quarter].[Number]
			INNER JOIN @Number AS [Number_MonthOccurrence]
				ON [Date].[DayOfWeekMonthOccurrenceNumber] = [Number_MonthOccurrence].[Number]
			INNER JOIN @Number AS [Number_DayOfMonthNumber]
				ON [Date].[DayOfMonthNumber] = [Number_DayOfMonthNumber].[Number]
