using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Microsoft.SqlServer.Server;
using WebRole.Models;

namespace WebRole.Controllers
{
    public class DatabaseService
    {
        public static void AddGenderInformation(string name, bool isMale)
        {
            using (var db = new RecommendedNamesEntities())
            {
                db.IncrementGender(name, isMale);
            }
        }

        public static IEnumerable<string> GetNamesByPrefix(string prefix)
        {
            using (var db = new RecommendedNamesEntities())
            {
                return db.GetNamesByPrefix(prefix).Select(r => r.Name).ToList();
            }
        }

        public static List<RelatedNameResult> GetRelatedNames(string include, string exclude, string block)
        {
            var results = new List<RelatedNameResult>();
            SqlMetaData[] tvpDefinition = { new SqlMetaData("n", SqlDbType.NVarChar, 50) };
            var includeList = BuildTableValueParameter(include.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries), tvpDefinition);
            var excludeList = BuildTableValueParameter(exclude.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries), tvpDefinition);
            var blockList = BuildTableValueParameter(block.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries), tvpDefinition);
            using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["RecommendedNames"].ConnectionString))
            {
                using (var cmd = cn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "[dbo].[GetRelatedNames]";

                    AddStringListParameter("@Names", includeList, cmd);
                    AddStringListParameter("@NamesExcluded", excludeList, cmd);
                    AddStringListParameter("@NamesBlocked", blockList, cmd);

                    try
                    {
                        cn.Open();
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                results.Add(new RelatedNameResult { 
                                    Name = reader[0].ToString(),
                                    Count = (int)reader[1],
                                    Sum = (int)reader[2],
                                    MaleCount = (int)reader[3],
                                    FemaleCount = (int)reader[4]
                                });
                            }
                        }
                    }
                    finally
                    {
                        cn.Close();
                    }
                }
            }
            return results;
        }

        private static void AddStringListParameter(string paramName, IEnumerable<SqlDataRecord> includeList, SqlCommand cmd)
        {
            if (!includeList.Any()) return;
            cmd.Parameters.Add(paramName, SqlDbType.Structured);
            cmd.Parameters[paramName].Direction = ParameterDirection.Input;
            cmd.Parameters[paramName].TypeName = "string50_list_tbltype";
            cmd.Parameters[paramName].Value = includeList;
        }

        private static IEnumerable<SqlDataRecord> BuildTableValueParameter(IEnumerable<string> list, SqlMetaData[] tvpDefinition)
        {
            var includeList = new List<SqlDataRecord>();
            foreach (var item in list)
            {
                var rec = new SqlDataRecord(tvpDefinition);
                rec.SetValue(0, item);
                includeList.Add(rec);
            }

            return includeList;
        }
    }
}