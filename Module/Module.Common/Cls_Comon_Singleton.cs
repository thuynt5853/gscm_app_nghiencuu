using System;
using System.Collections.Generic;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System.Net;

namespace Module.Common
{
    using System;

    public sealed class OracleDbConnection
    {
        private OracleConnection connection = null;

        // Lazy ensures thread safety and lazy initialization
        private static readonly Lazy<OracleDbConnection> instance = new Lazy<OracleDbConnection>(() => new OracleDbConnection());

        // Private constructor to prevent instantiation
        private OracleDbConnection()
        {
            //Console.WriteLine("Singleton Instance Created");
        }

        // Public property to access the instance
        public static OracleDbConnection Instance
        {
            get
            {
                return instance.Value;
            }
        }
        
        public OracleConnection OpenConnection()
        {
            String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
            OracleConnection conn = new OracleConnection(connection_string);
            conn.Open();
            return conn;
        }

        public OracleConnection getConnection()
        {
            //return OpenConnection();
            if (connection == null)
            {
                this.connection = OpenConnection();
            }

            //
            if (connection.State != System.Data.ConnectionState.Open)
            {
                // reopen
                connection = OpenConnection();
            }

            return connection;
        }
    
        public void terminateSession()
        {
            if (connection != null )
            {
                connection.Dispose();
                connection.Close();
            }
        }

    }

    }