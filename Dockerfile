FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["src/dockerWebApi.csproj", "src/"]
RUN dotnet restore "src/dockerWebApi.csproj"
COPY . .
WORKDIR /src/src
RUN dotnet build "dockerWebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerWebApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "dockerWebApi.dll"]
