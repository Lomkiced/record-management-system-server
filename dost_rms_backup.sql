--
-- PostgreSQL database dump
--

\restrict TJc8kSctZOBLgYsa9JIkbxIXVEFSbh4dgKZMFoZOKswnkFufAXuDC8yBkd7Vjjs

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-08 10:34:47

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 869 (class 1247 OID 26542)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'SUPER_ADMIN',
    'REGIONAL_ADMIN',
    'STAFF'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 26549)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    log_id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    details text,
    ip_address character varying(50),
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    region_id integer
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 26557)
-- Name: audit_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_log_id_seq OWNER TO postgres;

--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 220
-- Name: audit_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_log_id_seq OWNED BY public.audit_logs.log_id;


--
-- TOC entry 221 (class 1259 OID 26558)
-- Name: codex_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codex_categories (
    category_id integer NOT NULL,
    name character varying(100) NOT NULL,
    region character varying(50) DEFAULT 'Global'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.codex_categories OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 26565)
-- Name: codex_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.codex_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.codex_categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 222
-- Name: codex_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.codex_categories_category_id_seq OWNED BY public.codex_categories.category_id;


--
-- TOC entry 223 (class 1259 OID 26566)
-- Name: codex_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codex_types (
    type_id integer NOT NULL,
    category_id integer,
    type_name character varying(150) NOT NULL,
    retention_period character varying(50),
    region character varying(50) DEFAULT 'Global'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.codex_types OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 26573)
-- Name: codex_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.codex_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.codex_types_type_id_seq OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 224
-- Name: codex_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.codex_types_type_id_seq OWNED BY public.codex_types.type_id;


--
-- TOC entry 225 (class 1259 OID 26574)
-- Name: record_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_categories (
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.record_categories OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 26581)
-- Name: record_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.record_categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 226
-- Name: record_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_categories_category_id_seq OWNED BY public.record_categories.category_id;


--
-- TOC entry 227 (class 1259 OID 26582)
-- Name: record_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_types (
    type_id integer NOT NULL,
    category_id integer,
    type_name character varying(255) NOT NULL,
    retention_period character varying(100) DEFAULT '5 Years'::character varying,
    description text
);


ALTER TABLE public.record_types OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 26590)
-- Name: record_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.record_types_type_id_seq OWNER TO postgres;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 228
-- Name: record_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_types_type_id_seq OWNED BY public.record_types.type_id;


--
-- TOC entry 229 (class 1259 OID 26591)
-- Name: records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.records (
    record_id integer NOT NULL,
    title character varying(255) NOT NULL,
    region_id integer,
    category character varying(100),
    classification_rule character varying(255),
    file_path character varying(255),
    file_size bigint,
    file_type character varying(50),
    status character varying(50) DEFAULT 'Active'::character varying,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.records OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 26600)
-- Name: records_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.records_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.records_record_id_seq OWNER TO postgres;

--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 230
-- Name: records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.records_record_id_seq OWNED BY public.records.record_id;


--
-- TOC entry 231 (class 1259 OID 26601)
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    address character varying(255),
    status character varying(50) DEFAULT 'Active'::character varying
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26608)
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 232
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- TOC entry 233 (class 1259 OID 26609)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    system_name character varying(100) DEFAULT 'DOST-RMS'::character varying,
    org_name character varying(100) DEFAULT 'Department of Science and Technology'::character varying,
    logo_url text,
    login_bg_url text,
    primary_color character varying(20) DEFAULT '#4f46e5'::character varying,
    welcome_msg text DEFAULT 'Sign in to access the Enterprise Records Management System.'::text
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 26619)
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO postgres;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 234
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- TOC entry 235 (class 1259 OID 26620)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    region_id integer,
    office character varying(100),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    full_name character varying(100),
    email character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 26631)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 236
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4899 (class 2604 OID 26632)
-- Name: audit_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN log_id SET DEFAULT nextval('public.audit_logs_log_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 26633)
-- Name: codex_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories ALTER COLUMN category_id SET DEFAULT nextval('public.codex_categories_category_id_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 26634)
-- Name: codex_types type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types ALTER COLUMN type_id SET DEFAULT nextval('public.codex_types_type_id_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 26635)
-- Name: record_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories ALTER COLUMN category_id SET DEFAULT nextval('public.record_categories_category_id_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 26636)
-- Name: record_types type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types ALTER COLUMN type_id SET DEFAULT nextval('public.record_types_type_id_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 26637)
-- Name: records record_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records ALTER COLUMN record_id SET DEFAULT nextval('public.records_record_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 26638)
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 26639)
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 26640)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5105 (class 0 OID 26549)
-- Dependencies: 219
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (log_id, user_id, username, action, details, ip_address, user_agent, created_at, region_id) FROM stdin;
1	\N	System	SYSTEM_INIT	Audit Trail Module Initialized	127.0.0.1	\N	2026-01-03 15:04:19.64841	\N
2	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:09:37.230426	\N
3	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:15:24.451998	\N
5	\N	Super Admin	MANUAL_TEST	Verifying Audit System works	127.0.0.1	\N	2026-01-03 15:18:32.924652	\N
6	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:19:02.356296	\N
7	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:35:38.050531	\N
8	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:36:08.045148	\N
9	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:36:44.56488	\N
10	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:54:12.407155	\N
11	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:57:51.422162	\N
12	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:57:58.529388	\N
13	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:58:20.739579	\N
14	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:02:57.159839	\N
15	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:04:20.345946	\N
16	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:04:52.381181	\N
17	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:18:59.380171	\N
18	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:24:34.947545	\N
19	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:24:44.572335	\N
20	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:37:28.320285	\N
21	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:43:59.783333	\N
22	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:53:38.242035	\N
23	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:54:22.696881	\N
24	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:59:27.338258	\N
25	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:04:32.517861	\N
26	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:04:50.527847	\N
27	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:23.09791	\N
28	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:40.063351	\N
29	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:53.987656	\N
30	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:15:26.677902	\N
31	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:15:40.855157	\N
32	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:16:02.414735	\N
33	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:20:18.824132	\N
34	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:37:11.621138	\N
35	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:38:36.305166	\N
36	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:40:10.539351	\N
37	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:40:41.574872	\N
38	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:08:46.901773	\N
39	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:32:54.105554	\N
40	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 08:33:02.78504	\N
41	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:33:40.847553	\N
42	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 09:20:59.119986	\N
4	1	\N	UPLOAD_RECORD	Uploaded "Rich-Dad-Poor-Dad" to Region ID: 2	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:15:51.4148	1
43	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:55:38.653152	\N
44	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:56:17.054941	\N
45	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 14:57:46.595176	\N
46	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 14:58:20.051235	\N
47	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:59:35.252876	\N
48	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:13.788267	\N
49	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:36.527975	\N
50	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:47.762858	\N
51	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:21:06.665842	\N
52	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:21:29.820507	\N
53	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:22:53.664864	\N
54	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:23:07.132067	\N
55	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:48:22.755505	\N
56	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:52:17.609735	\N
57	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:56:51.973096	\N
58	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:56:59.385263	\N
59	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:57:13.44336	\N
60	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:06:35.483092	\N
61	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:07:40.843028	\N
62	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:10:47.488315	\N
63	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:11:07.206412	\N
64	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:29:48.746987	\N
65	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:34:21.63173	\N
66	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:39:44.082272	\N
67	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:56:55.334981	\N
68	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:10:34.483714	\N
69	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:11:04.092441	\N
70	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:13:13.519585	\N
71	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:13:50.602701	\N
72	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:15:07.917499	\N
\.


--
-- TOC entry 5107 (class 0 OID 26558)
-- Dependencies: 221
-- Data for Name: codex_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.codex_categories (category_id, name, region, created_at) FROM stdin;
4	Administrative and Management Records	Global	2025-12-26 14:10:57.061903
11	Budget Records	Global	2026-01-03 11:00:03.396859
\.


--
-- TOC entry 5109 (class 0 OID 26566)
-- Dependencies: 223
-- Data for Name: codex_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.codex_types (type_id, category_id, type_name, retention_period, region, created_at) FROM stdin;
6	4	Administrative Test 1	5 years	Global	2025-12-29 12:37:40.687896
7	4	Management Test 1	Permanent	Global	2025-12-29 12:37:54.720987
8	11	Budget Record Test 1	7 years	Global	2026-01-03 11:03:44.295922
\.


--
-- TOC entry 5111 (class 0 OID 26574)
-- Dependencies: 225
-- Data for Name: record_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_categories (category_id, name, description) FROM stdin;
1	Administrative and Management Records	\N
2	Budget Records	\N
3	Financial and Accounting Records	\N
4	Human Resource/Personnel Management Records	\N
5	Information Technology Records	\N
6	Legal Records	\N
7	Procurement and Supply Records	\N
8	Training Records	\N
\.


--
-- TOC entry 5113 (class 0 OID 26582)
-- Dependencies: 227
-- Data for Name: record_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_types (type_id, category_id, type_name, retention_period, description) FROM stdin;
1	3	Disbursement Vouchers	10 Years	\N
2	3	Audit Reports	Permanent	\N
3	4	201 Files	50 Years	\N
4	1	Project Proposals	3 years after completion	\N
5	1	Acknowledgement Receipts	1 year	\N
6	1	Certifications	1 year	\N
7	1	Gate Passes	6 month	\N
8	2	Annual	3 years	\N
9	1	Official Gazett	5	\N
\.


--
-- TOC entry 5115 (class 0 OID 26591)
-- Dependencies: 229
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.records (record_id, title, region_id, category, classification_rule, file_path, file_size, file_type, status, uploaded_at) FROM stdin;
1	Rich-Dad-Poor-Dad	1	Administrative and Management Records	Administrative Test 1	file-1767415969514-836425161.pdf	11863018	application/pdf	Active	2026-01-03 12:52:49.635512
2	Rich-Dad-Poor-Dad	7	Budget Records	Budget Record Test 1	file-1767424263164-842845210.pdf	11863018	application/pdf	Active	2026-01-03 15:11:03.388216
3	Rich-Dad-Poor-Dad	2	Administrative and Management Records	Management Test 1	file-1767424551161-871397025.pdf	11863018	application/pdf	Active	2026-01-03 15:15:51.39668
\.


--
-- TOC entry 5117 (class 0 OID 26601)
-- Dependencies: 231
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, name, code, address, status) FROM stdin;
1	Central Office	CO	\N	Active
2	National Capital Region	NCR	\N	Active
3	Cordillera Administrative Region	CAR	\N	Active
4	Region I - Ilocos	R1	\N	Active
5	Region II - Cagayan Valley	R2	\N	Active
6	Region III - Central Luzon	R3	\N	Active
7	La Union	R1.1	SFC, La Union	Active
\.


--
-- TOC entry 5119 (class 0 OID 26609)
-- Dependencies: 233
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, system_name, org_name, logo_url, login_bg_url, primary_color, welcome_msg) FROM stdin;
1	Record Management System	Department of Science and Technology	/uploads/1766450419483.png	/uploads/1766450419487.png	#4f46e5	Sign in to access the DOSTR1 Record Management System.
\.


--
-- TOC entry 5121 (class 0 OID 26620)
-- Dependencies: 235
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password, role, region_id, office, status, full_name, email, created_at, name) FROM stdin;
1	admin	password123	SUPER_ADMIN	1	Central Office	ACTIVE	System Administrator	admin@dost.gov.ph	2026-01-03 12:37:26.178718	admin
2	Ced	$2b$10$lsD70XhXLG1hdS/aUXuWFe0.nUEcNrhlW.sEZHZBh8nfZGltnzLWy	REGIONAL_ADMIN	7	Admin	ACTIVE	\N	\N	2026-01-03 14:06:59.245457	Ced
3	Mike	$2b$10$UszF5idGuedq7H8IIapL9OHcgSgYnCq.HZj.n5ZS3ydh8Kqik0p5e	STAFF	7	Staff	ACTIVE	\N	\N	2026-01-03 14:08:28.031321	Mike
4	Nerve	$2b$10$rGoAB/KZc2qD6UuWmpyEkewGIUoq9hMSoTaxwr1ssV1tSdX.dZS9K	ADMIN	2	NCR Admin	Active	\N	\N	2026-01-08 10:12:56.859415	Nerve Ferrer
\.


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 220
-- Name: audit_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_log_id_seq', 72, true);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 222
-- Name: codex_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.codex_categories_category_id_seq', 14, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 224
-- Name: codex_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.codex_types_type_id_seq', 8, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 226
-- Name: record_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_categories_category_id_seq', 24, true);


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 228
-- Name: record_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_types_type_id_seq', 9, true);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 230
-- Name: records_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.records_record_id_seq', 3, true);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 232
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 7, true);


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 234
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 1, false);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 236
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 4, true);


--
-- TOC entry 4924 (class 2606 OID 26642)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4930 (class 2606 OID 26644)
-- Name: codex_categories codex_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories
    ADD CONSTRAINT codex_categories_name_key UNIQUE (name);


--
-- TOC entry 4932 (class 2606 OID 26646)
-- Name: codex_categories codex_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories
    ADD CONSTRAINT codex_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4934 (class 2606 OID 26648)
-- Name: codex_types codex_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types
    ADD CONSTRAINT codex_types_pkey PRIMARY KEY (type_id);


--
-- TOC entry 4936 (class 2606 OID 26650)
-- Name: record_categories record_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories
    ADD CONSTRAINT record_categories_name_key UNIQUE (name);


--
-- TOC entry 4938 (class 2606 OID 26652)
-- Name: record_categories record_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories
    ADD CONSTRAINT record_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4940 (class 2606 OID 26654)
-- Name: record_types record_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_pkey PRIMARY KEY (type_id);


--
-- TOC entry 4942 (class 2606 OID 26656)
-- Name: records records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (record_id);


--
-- TOC entry 4944 (class 2606 OID 26658)
-- Name: regions regions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_code_key UNIQUE (code);


--
-- TOC entry 4946 (class 2606 OID 26660)
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- TOC entry 4948 (class 2606 OID 26662)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 26664)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4952 (class 2606 OID 26666)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4925 (class 1259 OID 26667)
-- Name: idx_audit_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_action ON public.audit_logs USING btree (action);


--
-- TOC entry 4926 (class 1259 OID 26668)
-- Name: idx_audit_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_date ON public.audit_logs USING btree (created_at);


--
-- TOC entry 4927 (class 1259 OID 26669)
-- Name: idx_audit_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_region ON public.audit_logs USING btree (region_id);


--
-- TOC entry 4928 (class 1259 OID 26670)
-- Name: idx_audit_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_user ON public.audit_logs USING btree (username);


--
-- TOC entry 4954 (class 2606 OID 26671)
-- Name: codex_types codex_types_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types
    ADD CONSTRAINT codex_types_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.codex_categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4953 (class 2606 OID 26676)
-- Name: audit_logs fk_audit_region; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_region FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- TOC entry 4955 (class 2606 OID 26681)
-- Name: record_types record_types_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.record_categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 26686)
-- Name: records records_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- TOC entry 4957 (class 2606 OID 26691)
-- Name: users users_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


-- Completed on 2026-01-08 10:34:47

--
-- PostgreSQL database dump complete
--

\unrestrict TJc8kSctZOBLgYsa9JIkbxIXVEFSbh4dgKZMFoZOKswnkFufAXuDC8yBkd7Vjjs

