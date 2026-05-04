IF DB_ID(N'$(DB_NAME)') IS NULL
BEGIN
  CREATE DATABASE [$(DB_NAME)];
END
GO

USE [$(DB_NAME)];
GO

IF SUSER_ID(N'$(DB_APP_USER)') IS NULL
BEGIN
  CREATE LOGIN [$(DB_APP_USER)] WITH PASSWORD = '$(DB_APP_PASSWORD)', CHECK_POLICY = OFF;
END
GO

IF USER_ID(N'$(DB_APP_USER)') IS NULL
BEGIN
  CREATE USER [$(DB_APP_USER)] FOR LOGIN [$(DB_APP_USER)];
END
GO

IF IS_ROLEMEMBER(N'db_owner', N'$(DB_APP_USER)') = 0
BEGIN
  ALTER ROLE [db_owner] ADD MEMBER [$(DB_APP_USER)];
END
GO

IF OBJECT_ID(N'dbo.[user]', N'U') IS NULL
BEGIN
  CREATE TABLE [user] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(10000, 1),
    [name] varchar(64) NOT NULL,
    [lastName] varchar(64) NOT NULL,
    [password] varchar(128) NOT NULL,
    [gender] nvarchar(255) NOT NULL CHECK ([gender] IN ('MALE', 'FEMALE')),
    [age] int NOT NULL,
    [identification] varchar(32) NOT NULL,
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [userType] nvarchar(255) NOT NULL CHECK ([userType] IN ('ADMIN', 'NORMAL')) DEFAULT 'NORMAL',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.[address]', N'U') IS NULL
BEGIN
  CREATE TABLE [address] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
    [idUser] integer NOT NULL,
    [address] varchar(128) NOT NULL,
    [typeAddress] varchar(32) NOT NULL,
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.[phone]', N'U') IS NULL
BEGIN
  CREATE TABLE [phone] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
    [idUser] integer,
    [phone] varchar(16) NOT NULL,
    [typePhone] varchar(32) NOT NULL,
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.[accountType]', N'U') IS NULL
BEGIN
  CREATE TABLE [accountType] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
    [accountType] varchar(32) NOT NULL,
    [accountCode] varchar(4) NOT NULL,
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.[account]', N'U') IS NULL
BEGIN
  CREATE TABLE [account] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
    [idAccountType] integer,
    [idUser] integer,
    [accountNumber] varchar(32) NOT NULL,
    [balance] decimal(19,2) NOT NULL,
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.[transactions]', N'U') IS NULL
BEGIN
  CREATE TABLE [transactions] (
    [id] integer PRIMARY KEY NOT NULL IDENTITY(1, 1),
    [idAccount] integer,
    [amount] decimal(19,2),
    [description] varchar(255) DEFAULT '',
    [concept] nvarchar(255) NOT NULL CHECK ([concept] IN ('DEBIT', 'CREDIT')),
    [status] nvarchar(255) NOT NULL CHECK ([status] IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    [created_at] datetime2 DEFAULT (SYSDATETIME()),
    [updated_at] datetime2
  );
END
GO

IF OBJECT_ID(N'dbo.FK_account_user', N'F') IS NULL
BEGIN
  ALTER TABLE [account] ADD CONSTRAINT [FK_account_user] FOREIGN KEY ([idUser]) REFERENCES [user] ([id]);
END
GO

IF OBJECT_ID(N'dbo.FK_phone_user', N'F') IS NULL
BEGIN
  ALTER TABLE [phone] ADD CONSTRAINT [FK_phone_user] FOREIGN KEY ([idUser]) REFERENCES [user] ([id]);
END
GO

IF OBJECT_ID(N'dbo.FK_address_user', N'F') IS NULL
BEGIN
  ALTER TABLE [address] ADD CONSTRAINT [FK_address_user] FOREIGN KEY ([idUser]) REFERENCES [user] ([id]);
END
GO

IF OBJECT_ID(N'dbo.FK_account_accountType', N'F') IS NULL
BEGIN
  ALTER TABLE [account] ADD CONSTRAINT [FK_account_accountType] FOREIGN KEY ([idAccountType]) REFERENCES [accountType] ([id]);
END
GO

IF OBJECT_ID(N'dbo.FK_transactions_account', N'F') IS NULL
BEGIN
  ALTER TABLE [transactions] ADD CONSTRAINT [FK_transactions_account] FOREIGN KEY ([idAccount]) REFERENCES [account] ([id]);
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '0000000000000')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Gerson', 'Ramos', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'MALE', 30, '0000000000000', 'ACTIVE', 'ADMIN');
END
GO

IF EXISTS (
  SELECT 1
  FROM [user]
  WHERE [identification] = '0000000000000'
    AND [password] = '$12$AwebjfTP8MdfwhFlFr3h9.eWLRoTBrm/gxLBbZ/KJidONHcMHR.My'
)
BEGIN
  UPDATE [user]
  SET [password] = '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK'
  WHERE [identification] = '0000000000000';
END
GO

IF NOT EXISTS (SELECT 1 FROM [accountType] WHERE [accountCode] = '3000')
BEGIN
  INSERT INTO [accountType] ([accountType], [accountCode])
  VALUES ('SAVING', '3000');
END
GO

IF NOT EXISTS (SELECT 1 FROM [accountType] WHERE [accountCode] = '4000')
BEGIN
  INSERT INTO [accountType] ([accountType], [accountCode])
  VALUES ('MONETARY', '4000');
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '1000000000001')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Ana', 'Lopez', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'FEMALE', 28, '1000000000001', 'ACTIVE', 'NORMAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '1000000000002')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Carlos', 'Mendez', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'MALE', 35, '1000000000002', 'ACTIVE', 'NORMAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '1000000000003')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Maria', 'Castillo', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'FEMALE', 42, '1000000000003', 'ACTIVE', 'NORMAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '1000000000004')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Luis', 'Herrera', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'MALE', 31, '1000000000004', 'ACTIVE', 'NORMAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM [user] WHERE [identification] = '1000000000005')
BEGIN
  INSERT INTO [user] ([name], [lastName], [password], [gender], [age], [identification], [status], [userType])
  VALUES ('Sofia', 'Garcia', '$2a$12$gandYZZXudUPuowsYTPW2uCuzGawnf5UX1QPys/ThbQXb7ya7hePK', 'FEMALE', 24, '1000000000005', 'ACTIVE', 'NORMAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501001')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '0000000000000'), '50255501001', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501011')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000001'), '50255501011', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501012')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000001'), '50255501012', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501021')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000002'), '50255501021', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501031')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000003'), '50255501031', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501041')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000004'), '50255501041', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [phone] WHERE [phone] = '50255501051')
BEGIN
  INSERT INTO [phone] ([idUser], [phone], [typePhone])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000005'), '50255501051', 'MOBILE');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '0000000000000') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '0000000000000'), 'Zona 10, Ciudad de Guatemala', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000001') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000001'), 'Zona 1, Ciudad de Guatemala', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000001') AND [typeAddress] = 'WORK')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000001'), 'Avenida Reforma 12-45, Zona 10', 'WORK');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000002') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000002'), 'Mixco, Colonia San Cristobal', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000003') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000003'), 'Antigua Guatemala, Calle del Arco', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000004') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000004'), 'Villa Nueva, Residenciales El Frutal', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [address] WHERE [idUser] = (SELECT [id] FROM [user] WHERE [identification] = '1000000000005') AND [typeAddress] = 'HOME')
BEGIN
  INSERT INTO [address] ([idUser], [address], [typeAddress])
  VALUES ((SELECT [id] FROM [user] WHERE [identification] = '1000000000005'), 'Quetzaltenango, Zona 3', 'HOME');
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '300000000001')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '3000'), (SELECT [id] FROM [user] WHERE [identification] = '0000000000000'), '300000000001', 2275.00);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '400000000001')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '4000'), (SELECT [id] FROM [user] WHERE [identification] = '0000000000000'), '400000000001', 800.00);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '300000000011')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '3000'), (SELECT [id] FROM [user] WHERE [identification] = '1000000000001'), '300000000011', 1475.50);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '400000000021')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '4000'), (SELECT [id] FROM [user] WHERE [identification] = '1000000000002'), '400000000021', 920.75);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '300000000031')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '3000'), (SELECT [id] FROM [user] WHERE [identification] = '1000000000003'), '300000000031', 3100.00);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '400000000041')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '4000'), (SELECT [id] FROM [user] WHERE [identification] = '1000000000004'), '400000000041', 545.25);
END
GO

IF NOT EXISTS (SELECT 1 FROM [account] WHERE [accountNumber] = '300000000051')
BEGIN
  INSERT INTO [account] ([idAccountType], [idUser], [accountNumber], [balance])
  VALUES ((SELECT [id] FROM [accountType] WHERE [accountCode] = '3000'), (SELECT [id] FROM [user] WHERE [identification] = '1000000000005'), '300000000051', 1850.00);
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001') AND [description] = 'Deposito inicial')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001'), 2500.00, 'Deposito inicial', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001') AND [description] = 'Pago de servicios')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001'), 350.00, 'Pago de servicios', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001') AND [description] = 'Intereses de ahorro')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000001'), 125.00, 'Intereses de ahorro', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001') AND [description] = 'Pago de nomina')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001'), 1200.00, 'Pago de nomina', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001') AND [description] = 'Compra supermercado')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001'), 180.00, 'Compra supermercado', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001') AND [description] = 'Retiro ATM')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000001'), 220.00, 'Retiro ATM', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000011') AND [description] = 'Deposito inicial')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000011'), 1500.50, 'Deposito inicial', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000011') AND [description] = 'Pago tarjeta')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000011'), 25.00, 'Pago tarjeta', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000021') AND [description] = 'Transferencia recibida')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000021'), 1000.75, 'Transferencia recibida', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000021') AND [description] = 'Pago de internet')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000021'), 80.00, 'Pago de internet', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000031') AND [description] = 'Deposito inicial')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000031'), 3200.00, 'Deposito inicial', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000031') AND [description] = 'Compra farmacia')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000031'), 100.00, 'Compra farmacia', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000041') AND [description] = 'Pago de nomina')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000041'), 700.25, 'Pago de nomina', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '400000000041') AND [description] = 'Compra combustible')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '400000000041'), 155.00, 'Compra combustible', 'DEBIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000051') AND [description] = 'Deposito inicial')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000051'), 2000.00, 'Deposito inicial', 'CREDIT');
END
GO

IF NOT EXISTS (SELECT 1 FROM [transactions] WHERE [idAccount] = (SELECT [id] FROM [account] WHERE [accountNumber] = '300000000051') AND [description] = 'Retiro en ventanilla')
BEGIN
  INSERT INTO [transactions] ([idAccount], [amount], [description], [concept])
  VALUES ((SELECT [id] FROM [account] WHERE [accountNumber] = '300000000051'), 150.00, 'Retiro en ventanilla', 'DEBIT');
END
GO
