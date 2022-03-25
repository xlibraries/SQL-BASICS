using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void GetEmployeeSP()
    {
        // Put your code here
        SqlPipe sqlPipe = SqlContext.Pipe;
        using (SqlConnection sqlConnection = new SqlConnection("context connection = true"))
        {
            sqlConnection.Open();
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = "SELECT * FROM EmployeeTable";
            SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
            sqlPipe.Send(sqlDataReader);
        }
    }
    /*
     *SqlPipe sp = SqlContext.Pipe;
        using (SqlConnection con = new SqlConnection("context connection=true"))
        {
            con.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.Text;
            cmd.Connection = con;
            cmd.CommandText = "select * from emptable1";
            SqlDataReader sdr = cmd.ExecuteReader();
            sp.Send(sdr);
        }
     */
}
