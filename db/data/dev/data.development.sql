--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1 (Debian 13.1-1.pgdg100+1)
-- Dumped by pg_dump version 13.1 (Debian 13.1-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hf_volunteer_portal_development; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE hf_volunteer_portal_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE hf_volunteer_portal_development OWNER TO admin;

\connect hf_volunteer_portal_development

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: identifiertype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.identifiertype AS ENUM (
    'EMAIL',
    'PHONE',
    'SLACK_ID',
    'GOOGLE_ID'
);


ALTER TYPE public.identifiertype OWNER TO admin;

--
-- Name: notificationchannel; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.notificationchannel AS ENUM (
    'EMAIL',
    'SMS',
    'SLACK'
);


ALTER TYPE public.notificationchannel OWNER TO admin;

--
-- Name: notificationstatus; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.notificationstatus AS ENUM (
    'SCHEDULED',
    'SENT',
    'FAILED'
);


ALTER TYPE public.notificationstatus OWNER TO admin;

--
-- Name: priority; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.priority AS ENUM (
    'TOP_PRIORITY',
    'HIGH',
    'MEDIUM',
    'LOW',
    'COULD_BE_NICE',
    'NONE'
);


ALTER TYPE public.priority OWNER TO admin;

--
-- Name: roletype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.roletype AS ENUM (
    'REQUIRES_APPLICATION',
    'OPEN_TO_ALL'
);


ALTER TYPE public.roletype OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.accounts (
    uuid uuid NOT NULL,
    username character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    _primary_email_identifier_uuid uuid,
    _primary_phone_number_identifier_uuid uuid
);


ALTER TABLE public.accounts OWNER TO admin;

--
-- Name: donation_emails; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.donation_emails (
    donation_uuid uuid NOT NULL,
    email text,
    request_sent_date timestamp without time zone
);


ALTER TABLE public.donation_emails OWNER TO admin;

--
-- Name: events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    event_name character varying(255) NOT NULL,
    event_graphics json[],
    signup_link text NOT NULL,
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone,
    description text
);


ALTER TABLE public.events OWNER TO admin;

--
-- Name: initiatives; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.initiatives (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    initiative_name character varying(255) NOT NULL,
    "order" integer NOT NULL,
    details_link character varying(255),
    hero_image_urls json[],
    description text NOT NULL,
    roles character varying[] NOT NULL,
    events character varying[] NOT NULL
);


ALTER TABLE public.initiatives OWNER TO admin;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.notifications (
    notification_uuid uuid NOT NULL,
    channel public.notificationchannel NOT NULL,
    recipient text NOT NULL,
    message text NOT NULL,
    scheduled_send_date timestamp without time zone NOT NULL,
    status public.notificationstatus NOT NULL,
    send_date timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO admin;

--
-- Name: personal_identifiers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.personal_identifiers (
    uuid uuid NOT NULL,
    type public.identifiertype NOT NULL,
    value text NOT NULL,
    account_uuid uuid,
    verified boolean NOT NULL
);


ALTER TABLE public.personal_identifiers OWNER TO admin;

--
-- Name: verification_tokens; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.verification_tokens (
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    already_used boolean NOT NULL,
    counter bigint NOT NULL,
    personal_identifier_uuid uuid
);


ALTER TABLE public.verification_tokens OWNER TO admin;

--
-- Name: volunteer_openings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.volunteer_openings (
    id character varying(255) NOT NULL,
    airtable_last_modified timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_deleted boolean NOT NULL,
    uuid uuid NOT NULL,
    role_name character varying(255) NOT NULL,
    hero_image_urls json[],
    application_signup_form text,
    more_info_link text,
    priority public.priority NOT NULL,
    team character varying(255)[],
    team_lead_ids character varying(255)[],
    num_openings integer,
    minimum_time_commitment_per_week_hours integer,
    maximum_time_commitment_per_week_hours integer,
    job_overview text,
    what_youll_learn text,
    responsibilities_and_duties text,
    qualifications text,
    role_type public.roletype NOT NULL
);


ALTER TABLE public.volunteer_openings OWNER TO admin;

--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.accounts (uuid, username, first_name, last_name, _primary_email_identifier_uuid, _primary_phone_number_identifier_uuid) FROM stdin;
\.


--
-- Data for Name: donation_emails; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.donation_emails (donation_uuid, email, request_sent_date) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, airtable_last_modified, updated_at, is_deleted, uuid, event_name, event_graphics, signup_link, start, "end", description) FROM stdin;
3300191229134	2021-02-25 00:23:22.583102	2021-02-28 00:23:22.583102	f	c4bc9edb-967f-494e-bf77-fe7b96da3498	Per some family shake.	{}	https://cummings.info/	2021-03-07 00:23:22.583102	2021-03-11 00:23:22.583102	Indeed goal officer conference apply. President team picture teacher economy approach do. Book detail hotel pattern hospital walk.
8907292776175	2021-03-03 00:23:22.583776	2021-03-07 00:23:22.583776	f	1532d78e-9d8f-491b-95be-c8a71649ae62	Ready officer note catch care speech sister.	{}	https://waters.com/search/post/	2021-03-14 00:23:22.583776	2021-03-16 00:23:22.583776	Officer pattern to cold evening minute stuff. Car speech base research truth law adult. Four oil however point well usually. Night understand board few surface student teacher. Window home stay a trade.
3535855936930	2021-02-25 00:23:22.584091	2021-03-02 00:23:22.584091	f	3c6d2445-3e1e-43fd-92e8-7ea431c5850d	Next eight sure appear.	{}	https://bowen.net/search/	2021-03-09 00:23:22.584091	2021-03-17 00:23:22.584091	Increase financial test face. Social rather defense attention work per. Arm green design war which.
8150385747501	2021-02-28 00:23:22.584374	2021-03-04 00:23:22.584374	f	bbbcd63c-b99b-4445-9567-fb6481fa127a	Hotel fund change return reality.	{}	http://kane.biz/	2021-03-10 00:23:22.584374	2021-03-11 00:23:22.584374	Trial phone factor realize road. I friend decide imagine dog.
0950095115779	2021-02-26 00:23:22.584841	2021-03-03 00:23:22.584841	f	36cec5fd-f368-4e7c-8dc0-bf8889d4d1af	Republican school look fill amount buy oil.	{"{\\"url\\": \\"https://placeimg.com/711/644/any\\"}"}	https://www.davis.com/post.htm	2021-03-09 00:23:22.584841	2021-03-13 00:23:22.584841	Anyone size during. White drug executive many she of. Stage attorney believe region professor at western long. All adult local authority site either test. Bank decade her affect effort tend when real.
1584522449886	2021-02-21 00:23:22.594003	2021-02-25 00:23:22.594003	f	b25d8a6a-6e76-4252-92ad-f5c15f68fe37	Politics and into role.	{"{\\"url\\": \\"https://placeimg.com/366/492/any\\"}"}	http://www.smith.biz/tags/search/categories/author.html	2021-03-05 00:23:22.594003	2021-03-14 00:23:22.594003	Range author power article whom rich. Question likely along maybe focus suddenly weight.
7486891750010	2021-02-17 00:23:22.594428	2021-02-20 00:23:22.594428	f	240b7634-7d1c-4cab-bb95-3218dba231ac	Clear economic concern safe.	{"{\\"url\\": \\"https://placekitten.com/311/581\\"}"}	https://www.mccormick.com/	2021-02-28 00:23:22.594428	2021-03-08 00:23:22.594428	Pretty beat treatment brother away. Management report commercial area play score box. Attorney note wear believe game difference. Knowledge federal understand feeling.
5239192806731	2021-02-25 00:23:22.594737	2021-03-03 00:23:22.594737	f	ca5b890f-f8ab-4cea-93e5-4809386a15f7	Far look base.	{}	https://www.keith.com/post/	2021-03-09 00:23:22.594737	2021-03-16 00:23:22.594737	Spring buy professor her. War leader when evening. Stage girl clear. Will together strategy number enjoy.
1984649331253	2021-02-20 00:23:22.597049	2021-02-23 00:23:22.597049	f	7716e808-ecb3-4dc1-8b49-7cc092c767e0	Style any appear but raise turn.	{"{\\"url\\": \\"https://placekitten.com/150/142\\"}"}	https://www.mcgee.info/blog/terms.jsp	2021-03-03 00:23:22.597049	2021-03-07 00:23:22.597049	Who player learn everything building. Very party color information away property across attack. Goal skin nor meet difference risk. Clear item treat these off base.
0088706507290	2021-02-13 00:23:22.597312	2021-02-15 00:23:22.597312	f	d21f125a-07bc-4534-b3f5-0987f079628e	Item order someone model program during.	{"{\\"url\\": \\"https://placekitten.com/906/602\\"}"}	https://brown.org/category/list/about/	2021-02-23 00:23:22.597312	2021-02-27 00:23:22.597312	Yet join carry attention respond. Study stuff same everybody. Laugh nation fall serve. Weight course operation.
2937049346210	2021-02-28 00:23:22.597736	2021-03-05 00:23:22.597736	f	ac40a53e-ae0b-474c-bdec-713aa2b05f46	Box cup strategy no too beyond.	{}	http://jackson.com/	2021-03-11 00:23:22.597736	2021-03-15 00:23:22.597736	Behind billion serious station all know. Lay section personal her mission theory. Claim end he create decision.
1070622794396	2021-03-01 00:23:22.599546	2021-03-06 00:23:22.599546	f	39b8a849-f3b3-4fda-99de-f52b55098950	Perhaps same grow support economic expect.	{"{\\"url\\": \\"https://www.lorempixel.com/288/969\\"}"}	http://moody-espinoza.com/categories/terms/	2021-03-13 00:23:22.599546	2021-03-14 00:23:22.599546	Guy also threat similar. Real green inside ball. Something remain something across water accept election. Number five hundred far door standard. Yet item practice effort party.
5182551633847	2021-02-28 00:23:22.599947	2021-03-02 00:23:22.599947	f	45a1c48e-8c5e-44b1-8eb5-82d59e1047f0	Section collection house sister capital address.	{"{\\"url\\": \\"https://placekitten.com/409/840\\"}"}	https://hawkins-meyer.org/post/	2021-03-10 00:23:22.599947	2021-03-20 00:23:22.599947	Today gas purpose reach again. Learn common benefit sit bag finally. Before manage above decade. That energy win avoid phone agency difficult college.
9815950382868	2021-02-23 00:23:22.60024	2021-02-27 00:23:22.60024	f	fbfbfe23-3d8b-4fbb-83b2-235213393753	Officer possible time alone.	{}	https://jackson.net/	2021-03-07 00:23:22.60024	2021-03-11 00:23:22.60024	Science act final much. She wide have weight south land. Trial move staff bed.
\.


--
-- Data for Name: initiatives; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.initiatives (id, airtable_last_modified, updated_at, is_deleted, uuid, initiative_name, "order", details_link, hero_image_urls, description, roles, events) FROM stdin;
8745618508839	2021-02-18 00:23:22.595213	2021-02-23 00:23:22.595213	f	d8373958-98b0-4f36-af3d-b4ea61c1c8cf	Douglas Moss	1	https://holmes.com/privacy.html	{"{\\"url\\": \\"https://placeimg.com/586/306/any\\"}"}	Officer money street boy black. Security war find minute song. Short owner deal machine technology. Start inside more every interesting anyone themselves. Sing stay action now southern argue.	{2104571462002,8098324908838}	{1584522449886,7486891750010,5239192806731}
4347781350907	2021-03-04 00:23:22.597979	2021-03-07 00:23:22.597979	f	03a52add-58e6-4293-bc2a-10e315fd43fc	Veronica Rodriguez	2	http://price.com/posts/list/faq.html	{"{\\"url\\": \\"https://dummyimage.com/326x213\\"}"}	Exist friend go force doctor. More present which many college eat wait force. Table believe around end. Agree less expert example realize onto include.	{4544800872284,5801163223993}	{1984649331253,0088706507290,2937049346210}
7709859004865	2021-02-22 00:23:22.600461	2021-02-26 00:23:22.600461	f	3659cf20-654a-400b-90f4-be9ddbc03459	Paul Shaw Jr.	3	https://long.com/	{}	Require health contain buy trial call. Thought last night. Peace most firm artist.	{2216758044038,8698515287676}	{1070622794396,5182551633847,9815950382868}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (notification_uuid, channel, recipient, message, scheduled_send_date, status, send_date) FROM stdin;
\.


--
-- Data for Name: personal_identifiers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.personal_identifiers (uuid, type, value, account_uuid, verified) FROM stdin;
\.


--
-- Data for Name: verification_tokens; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.verification_tokens (uuid, created_at, already_used, counter, personal_identifier_uuid) FROM stdin;
\.


--
-- Data for Name: volunteer_openings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.volunteer_openings (id, airtable_last_modified, updated_at, is_deleted, uuid, role_name, hero_image_urls, application_signup_form, more_info_link, priority, team, team_lead_ids, num_openings, minimum_time_commitment_per_week_hours, maximum_time_commitment_per_week_hours, job_overview, what_youll_learn, responsibilities_and_duties, qualifications, role_type) FROM stdin;
4006734530987	2021-02-24 00:23:22.567502	2021-03-01 00:23:22.567502	f	76ad602d-54ff-4307-b4d3-f2eac945d045	Build ever purpose finish toward himself clearly.	{"{\\"url\\": \\"https://placeimg.com/74/829/any\\"}"}	http://herrera.org/author.asp	http://www.silva.com/	MEDIUM	{3558547375541}	{}	6	2	8	Common space Mrs quickly coach. Stuff claim week simple compare article lawyer guess. Threat some much off.	Page give ahead son. Continue suffer run west bit glass. Start truth forget.	Left sport bit imagine despite investment. Management so leg loss together. Trial major film. Anyone involve very cold leg training rich.	Go machine color television know service simple. Hear weight strategy organization let task. Usually yet all spring others American tell.	REQUIRES_APPLICATION
6381098739305	2021-02-17 00:23:22.569388	2021-02-20 00:23:22.569388	f	025d05ac-4165-4fb2-9d54-a0caafb149c8	Respond point other dog vote range.	{"{\\"url\\": \\"https://dummyimage.com/432x710\\"}"}	https://kelly.com/	http://oconnor.org/home/	MEDIUM	{2360469780652}	{3432728124961}	6	8	4	Explain lay life next herself television high. Past issue past boy baby apply rock. Like no now if both policy. Actually young scientist kind.	Nation truth popular newspaper lawyer anyone beautiful. Result face summer key news sense training national. Support like challenge reason blue. Court serve outside represent.	Term imagine arrive commercial Mrs. Color your nice consumer animal discussion. Brother watch those say. Next possible blood every.	More different wonder. Trial tend same billion. Almost surface management I figure year. Method occur chance food executive.	OPEN_TO_ALL
6721070386811	2021-02-18 00:23:22.570288	2021-02-20 00:23:22.570288	f	0bd57bae-cf74-4bde-aeed-b431ed1a85eb	Together it best dog collection describe.	{"{\\"url\\": \\"https://www.lorempixel.com/444/358\\"}"}	http://www.watson.biz/list/search/	http://www.allen.org/privacy/	MEDIUM	{7209082131753}	{}	3	8	7	Thousand open bill could. Whom wear step economic security miss. Wrong future fish reality opportunity now himself management.	Something development impact. Sister positive energy perhaps. Lead town rich want idea last. Compare say third break.	Series arrive see summer ability shake own. The exactly enough subject.	Try morning country company large month. Financial physical if out himself drop do clear.	REQUIRES_APPLICATION
7484497793707	2021-02-27 00:23:22.571355	2021-03-03 00:23:22.571355	f	1f19770e-59ba-4f81-9dc7-5f012f42f828	Bar PM between smile ago word expert.	{"{\\"url\\": \\"https://dummyimage.com/385x325\\"}"}	http://www.duke.info/app/explore/category/faq/	https://www.kennedy-stevenson.com/categories/list/wp-content/register.html	MEDIUM	{2453235904229}	{5346271778640}	2	5	3	Project already kitchen machine five far. Manage bill single home how establish almost. Allow if final fly. Rather officer sure child year good show improve. Lay democratic leader alone standard drug available include.	Better put itself entire. To coach officer establish fear feel want specific. Party task really language drive good. Feel through day above interesting next change.	Down marriage vote middle. Standard different avoid full.	Western population short allow such life piece movement. Blood off speak all best her.	OPEN_TO_ALL
6339914152326	2021-02-23 00:23:22.572558	2021-02-26 00:23:22.572558	f	c4b00951-8b6c-4973-9b41-d4aa7d0a1f5c	Have arm really.	{"{\\"url\\": \\"https://placekitten.com/339/208\\"}"}	https://lyons.com/category/search/	http://www.smith.biz/privacy/	MEDIUM	{6058780355524}	{}	5	9	9	Challenge two choice office. Car set appear after. Difference participant night offer order run Mrs. Each green wall act somebody news.	Hope trip every yourself skin continue check others. It call space product budget likely though. Field wish candidate. Society around rest public behavior.	Hotel former head series lose inside change indeed. Bad skin teacher heart learn authority understand concern. Full suddenly scene form. Force will drop provide. Bring upon when party response team various.	Under yard turn again nor. Feeling him there it news example effect today. Represent care part hope stock respond might hundred.	REQUIRES_APPLICATION
2104571462002	2021-02-23 00:23:22.59242	2021-02-27 00:23:22.59242	f	af96b394-0ed1-4e62-abc7-99f9b1c2b304	Gas parent chair pick should work.	{"{\\"url\\": \\"https://placekitten.com/644/886\\"}"}	http://turner.com/posts/post.htm	http://www.rich-gibbs.org/wp-content/category/	MEDIUM	{9225709592309}	{5117462194958}	3	9	6	Live billion blue executive. Protect size miss start his lose pass.	For draw deal less customer light run. Scientist night court officer argue budget. Either hotel dog world. Industry away her director field contain.	Read name road five send claim sometimes. Discover find rule effect drive summer. Case now account improve. Just democratic herself article miss. Able base bed which one.	Majority possible collection thank range. Quality for spring sound themselves course friend. Agree tough full PM hair agent. Loss more owner think.	OPEN_TO_ALL
8098324908838	2021-02-27 00:23:22.593288	2021-03-03 00:23:22.593288	f	8f877fa6-cc1a-401b-8dd4-55b3aaa2ab20	Head the understand music.	{"{\\"url\\": \\"https://placeimg.com/855/453/any\\"}"}	http://www.randall-edwards.com/terms.htm	http://www.gray.com/category/main/	MEDIUM	{0072812894207}	{}	2	4	4	Himself action describe recognize. House concern situation response role off glass. Some between cover inside consumer tough beat raise. Baby key industry because lose training will. Identify day ten.	Bag here push simply style coach adult. Between near cup well.	Piece no it. Perhaps together very country game article ok. House project level marriage throw.	Two mission picture piece born truth. Executive great look so outside bad. Conference as pay my. But magazine particular seven company do.	OPEN_TO_ALL
4544800872284	2021-02-15 00:23:22.595804	2021-02-20 00:23:22.595804	f	c0e4e942-bdb1-40b3-974b-aaa055826f63	Prove party possible fast senior glass.	{"{\\"url\\": \\"https://dummyimage.com/937x575\\"}"}	https://www.estes-rivera.org/home.htm	https://pineda-park.info/	MEDIUM	{6804412186031}	{0822742414828}	3	9	5	Mouth skill sound region reach follow available. Work later party. Career number them health collection.	Left window western. Put born will. Design discover day final result explain.	Time consumer bank year economy rich friend. Wife list cause idea force. Hear great bag sometimes.	People yet state create realize source. Coach short soon number knowledge stage human. Body his detail draw available everybody suggest. Response take office free class. Tree century attorney poor.	REQUIRES_APPLICATION
5801163223993	2021-02-16 00:23:22.596401	2021-02-19 00:23:22.596401	f	9274ba78-e0df-4b31-8919-32fd176e5ec2	Smile kitchen against success teach.	{"{\\"url\\": \\"https://dummyimage.com/968x880\\"}"}	http://carter-douglas.com/search/	https://www.lane-stevens.com/main/	MEDIUM	{2920131949420}	{9786158689878}	3	3	6	Main seek ball customer force feeling. Establish responsibility people choice decade possible current. Cell standard still recently. Least easy like church interesting section speak. Team approach parent everybody vote a.	Alone than then international safe political later. This determine industry. Could between center. Specific too coach.	Science way son like significant person. Onto guess product sing person theory strong turn. As write read morning beautiful raise candidate.	Great attack foreign out foot once physical. Water despite knowledge. Middle bed girl property. Human good blue story series remember main.	REQUIRES_APPLICATION
2216758044038	2021-03-04 00:23:22.598378	2021-03-07 00:23:22.598378	f	86266c46-1aa2-48f7-b471-b1337f2d9d92	Investment kid remember.	{"{\\"url\\": \\"https://placeimg.com/830/332/any\\"}"}	http://www.lee-estes.org/list/main/main/search/	https://beasley-nelson.biz/explore/blog/about.html	MEDIUM	{2930525941329}	{}	2	8	5	Country who reflect understand way better. Rock those authority force none together. Bad teacher store simply everyone. Side fast make suggest him appear pass.	Quickly under hit their. Scene administration nothing.	Join clearly style include accept much. Turn professional maintain responsibility individual speech.	Body spring manager interesting series local. Choose high bill white boy yes site forward.	REQUIRES_APPLICATION
8698515287676	2021-02-16 00:23:22.599004	2021-02-20 00:23:22.599004	f	e846cc01-26b8-4193-b3b3-12bb1ab61d55	Fire federal street religious media.	{}	https://www.george.com/search/category/tags/author.html	https://www.mitchell.com/	MEDIUM	{8376949943732}	{5956418824309}	6	4	6	Property rich must recognize. Fly ok lay represent talk. Campaign now final born be.	Animal individual oil room foreign your. Fear car draw majority growth participant light. Else deal believe soon life particularly. Charge son Republican.	Statement bank wind these gun. Head time be list book himself wish.	Figure against building. Purpose smile meet you operation. Star hundred just democratic since play.	REQUIRES_APPLICATION
\.


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (uuid);


--
-- Name: donation_emails donation_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.donation_emails
    ADD CONSTRAINT donation_emails_pkey PRIMARY KEY (donation_uuid);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (uuid);


--
-- Name: initiatives initiatives_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.initiatives
    ADD CONSTRAINT initiatives_pkey PRIMARY KEY (uuid);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_uuid);


--
-- Name: personal_identifiers personal_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_pkey PRIMARY KEY (uuid);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (uuid);


--
-- Name: volunteer_openings volunteer_openings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.volunteer_openings
    ADD CONSTRAINT volunteer_openings_pkey PRIMARY KEY (uuid);


--
-- Name: accounts accounts__primary_email_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_email_identifier_uuid_fkey FOREIGN KEY (_primary_email_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: accounts accounts__primary_phone_number_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts__primary_phone_number_identifier_uuid_fkey FOREIGN KEY (_primary_phone_number_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- Name: personal_identifiers personal_identifiers_account_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.personal_identifiers
    ADD CONSTRAINT personal_identifiers_account_uuid_fkey FOREIGN KEY (account_uuid) REFERENCES public.accounts(uuid);


--
-- Name: verification_tokens verification_tokens_personal_identifier_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_personal_identifier_uuid_fkey FOREIGN KEY (personal_identifier_uuid) REFERENCES public.personal_identifiers(uuid);


--
-- PostgreSQL database dump complete
--

