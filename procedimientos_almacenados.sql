USE [CursosOnline]
GO
/****** Object:  StoredProcedure [dbo].[usp_instructor_editar]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_instructor_editar](
	@InstructorId uniqueidentifier,
	@Nombre nvarchar(500),
	@Apellidos nvarchar(500),
	@Titulo nvarchar(100)
)
AS
	BEGIN

		UPDATE Instructor 
		SET 
			Nombre = @Nombre,
			Apellidos = @Apellidos,
			Grado = @Titulo,
			FechaCreacion = GetUTCDate()
		WHERE InstructorId = @InstructorId


	END
GO
/****** Object:  StoredProcedure [dbo].[usp_instructor_elimina]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_instructor_elimina](
	@InstructorId uniqueidentifier
)
AS
	BEGIN

		DELETE FROM CursoInstructor WHERE InstructorId = @InstructorId

		DELETE FROM Instructor WHERE InstructorId = @InstructorId


	END
GO
/****** Object:  StoredProcedure [dbo].[usp_instructor_nuevo]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_instructor_nuevo](
	@InstructorId uniqueidentifier,
	@Nombre nvarchar(500),
	@Apellidos nvarchar(500),
	@Titulo nvarchar(100)
)
AS
	BEGIN

		INSERT INTO Instructor(InstructorId, Nombre, Apellidos, Grado, FechaCreacion)
		VALUES(@InstructorId, @Nombre, @Apellidos, @Titulo, GetUTCDate())

	END
GO
/****** Object:  StoredProcedure [dbo].[usp_obtener_curso_paginacion]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_obtener_curso_paginacion](
	@NombreCurso nvarchar(500),
	@Ordenamiento nvarchar(500),
	@NumeroPagina int,
	@CantidadElementos int,
	@TotalRecords int OUTPUT,
	@TotalPaginas int OUTPUT
)AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @Inicio int
	DECLARE @Fin int

	IF @NumeroPagina = 1
		BEGIN
			SET @Inicio = (@NumeroPagina*@CantidadElementos) - @CantidadElementos
			SET @Fin = @NumeroPagina * @CantidadElementos
		END
	ELSE
		BEGIN
			SET @Inicio = ( (@NumeroPagina*@CantidadElementos) - @CantidadElementos ) + 1
			SET @Fin = @NumeroPagina * @CantidadElementos
		END

	CREATE TABLE #TMP(
		rowNumber int IDENTITY(1,1),
		ID uniqueidentifier
	)

	DECLARE @SQL nvarchar(max)
	SET @SQL = ' SELECT CursoId FROM Curso '
	
	IF @NombreCurso IS NOT NULL
		BEGIN
			SET @SQL = @SQL + ' WHERE Titulo LIKE ''%' + @NombreCurso +'%''  '
		END

	IF @Ordenamiento IS NOT NULL
		BEGIN
			SET @SQL = @SQL + ' ORDER BY  ' + @Ordenamiento
		END

	--SELECT CursoId FROM Curso WHERE Titulo LIKE '% ASP %' ORDER BY Titulo

	INSERT INTO #TMP(ID)
	EXEC sp_executesql @SQL

	SELECT @TotalRecords =Count(*) FROM #TMP

	IF @TotalRecords > @CantidadElementos 
		BEGIN
			SET @TotalPaginas = @TotalRecords / @CantidadElementos
			IF (@TotalRecords % @CantidadElementos) > 0
				BEGIN
					SET @TotalPaginas = @TotalPaginas + 1 
				END

		END
	ELSE
		BEGIN
			SET @TotalPaginas = 1
		END


		SELECT 
			c.CursoId,
			c.Titulo,
			c.Descripcion,
			c.FechaPublicacion,
			c.FotoPortada,
			c.FechaCreacion,
			p.PrecioActual,
			p.Promocion
		FROM #TMP t INNER JOIN dbo.Curso c 
						ON t.ID = c.CursoId
					LEFT JOIN Precio p 
						ON c.CursoId = p.CursoId
		 WHERE t.rowNumber >= @Inicio AND t.rowNumber <= @Fin
		
END
GO
/****** Object:  StoredProcedure [dbo].[usp_obtener_instructor_por_id]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_obtener_instructor_por_id] (
	@Id uniqueidentifier
)
AS
	BEGIN

		SELECT 
			InstructorId,
			Nombre,
			Apellidos,
			Grado AS Titulo,
			FechaCreacion 
		from Instructor WHERE InstructorId = @Id


	END
GO
/****** Object:  StoredProcedure [dbo].[usp_Obtener_Instructores]    Script Date: 6/22/2020 9:53:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Obtener_Instructores]
AS
	BEGIN
		SET NOCOUNT ON

		SELECT 
			X.InstructorId,
			X.Nombre,
			X.Apellidos,
			X.Grado AS Titulo,
			X.FechaCreacion
		FROM Instructor X


	END
GO
