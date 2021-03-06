USE [RecommendedNames]
GO
/****** Object:  Table [dbo].[FirstName]    Script Date: 05/28/2011 07:59:06 ******/
CREATE TABLE [dbo].[FirstName](
	[Name] [nvarchar](50) NOT NULL,
	[Count] [int] NOT NULL,
	[Sum] [int] NOT NULL,
	[MaleCount] [int] NOT NULL,
	[FemaleCount] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[string50_list_tbltype]    Script Date: 05/28/2011 07:59:40 ******/
CREATE TYPE [dbo].[string50_list_tbltype] AS TABLE(
	[n] [nvarchar](50) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[n] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  Table [dbo].[RelatedNames]    Script Date: 05/28/2011 07:59:28 ******/
CREATE TABLE [dbo].[RelatedNames](
	[Seed] [nvarchar](50) NOT NULL,
	[Result] [nvarchar](50) NOT NULL,
	[Weight] [int] NOT NULL,
	[ResultSum] [int] NOT NULL,
	[ResultCount] [int] NOT NULL
)
GO
/****** Object:  Table [dbo].[LetterDistribution]    Script Date: 05/28/2011 07:59:15 ******/
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LetterDistribution](
	[Letter] [char](1) NOT NULL,
	[SeedCount] [int] NOT NULL,
	[ResultCount] [int] NOT NULL,
	[Percentage]  AS ([SeedCount]/((1.0)*[ResultCount])) PERSISTED,
 CONSTRAINT [PK_LetterDistribution] PRIMARY KEY CLUSTERED 
(
	[Letter] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
GO
SET ANSI_PADDING OFF
GO
