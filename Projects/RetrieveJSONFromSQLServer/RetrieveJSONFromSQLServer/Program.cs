using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RetrieveJSONFromSQLServer
{
    class Program
    {
        static void Main(string[] args)
        {
                string connString = @"Data Source=ZALNET-PC\SQLDEV2017;Initial Catalog=RetrieveJSONFromSQLServer; Integrated Security=True";
                string sprocname = "uspRetrievePerformanceCounterData";
                string jsonOutputParam = "@jsonOutput";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(sprocname, conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        // Create output parameter. "-1" is used for nvarchar(max)
                        cmd.Parameters.Add(jsonOutputParam, SqlDbType.NVarChar, -1).Direction = ParameterDirection.Output;

                        // Execute the command
                        cmd.ExecuteNonQuery();

                        // Get the values
                        string json = cmd.Parameters[jsonOutputParam].Value.ToString();

                        Console.WriteLine(json);
                        Console.ReadKey();
                    }
                }
        }
    }
}
