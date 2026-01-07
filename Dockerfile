# =========================
# =========================
# 1. Build Stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
 
# Copy project files and restore dependencies
COPY *.sln ./
COPY ./*.csproj ./RuiRiccaFinal/
RUN dotnet restore
 
# Copy the rest of the source code
COPY . .
 
# Publish the app in Release mode
RUN dotnet publish ./RuiRiccaFinal.csproj -c Release -o /app/publish
 
# =========================
# 2. Runtime Stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
 
# Copy published files from build stage
COPY --from=build /app/publish .
 
# Expose port (default for Kestrel)
EXPOSE 8080
 
# Set environment variables for production
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    ASPNETCORE_URLS=http://+:8080
 
# Start the application
ENTRYPOINT ["dotnet", "RuiRiccaFinal.dll"]
