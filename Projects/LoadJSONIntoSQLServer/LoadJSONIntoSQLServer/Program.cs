using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace LoadJSONIntoSQLServer
{
    class Program
    {
        static void Main(string[] args)
        {
            string connString = @"Data Source=ZALNET-PC\SQLDEV2017;Initial Catalog=LoadJSONIntoSQLServer;Integrated Security=True";
            string sprocname = "uspInsertPerformanceCounterData";
            string paramName = "@json";
            // Sample JSON string 
            string paramValue = "{\"dateTime\":\"2019-03-07T15:15:40.222Z\",\"dateTimeLocal\":\"2019-03-07T11:15:40.222Z\",\"cpuPercentProcessorTime\":\"0\",\"memoryAvailableInGB\":\"28\"}";
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(sprocname, conn))
                {
                    // Set command object as a stored procedure
                    cmd.CommandType = CommandType.StoredProcedure;
                    // Add parameter that will be passed to stored procedure
                    cmd.Parameters.Add(new SqlParameter(paramName, paramValue));
                    cmd.ExecuteReader();
                }
            }
        }
    }
}
