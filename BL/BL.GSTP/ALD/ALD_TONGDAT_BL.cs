using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;


namespace BL.GSTP.ALD
{
    public class ALD_TONGDAT_BL
    {
        public DataTable ALD_TONGDATDOITUONG_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("vDonID", vDONID),
                 new OracleParameter("vToaAnID", vTOAANID),
                 new OracleParameter("vBieuMauID", vBIEUMAUID),
                 new OracleParameter("vIsOnLyNKK", vIsOnlyNKK),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBY", parameters);;
        }
        public DataTable ALD_TONGDATDOITUONG_GETBYFILEID(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK, decimal vFileID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("vDonID", vDONID),
                 new OracleParameter("vToaAnID", vTOAANID),
                 new OracleParameter("vBieuMauID", vBIEUMAUID),
                 new OracleParameter("vIsOnLyNKK", vIsOnlyNKK),
                 new OracleParameter("vFileID", vFileID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBY", parameters); ;
        }
        public DataTable ALD_TONGDATDOITUONG_ANPHI_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK, decimal vANPHIID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("vDonID", vDONID),
                 new OracleParameter("vToaAnID", vTOAANID),
                 new OracleParameter("vBieuMauID", vBIEUMAUID),
                 new OracleParameter("vIsOnLyNKK", vIsOnlyNKK),
                 new OracleParameter("vANPHIID", vANPHIID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT_ANPHI.ALD_TONGDATDOITUONG_GETBY", parameters); ;
        }

        public DataTable ALD_TONGDATDOITUONG_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vTONGDATID, decimal vIsOnlyNKK)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("vDonID" , vDONID),
                 new OracleParameter("vToaAnID" , vTOAANID),
                 new OracleParameter("vBieuMauID" , vBIEUMAUID),
                 new OracleParameter("vIsOnLyNKK" , vIsOnlyNKK),
                 new OracleParameter("vTongDatID" , vTONGDATID) , 
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBY2", parameters); ;
        }

        public DataTable ALD_TONGDATDOITUONG_GETBYTONGDATID(decimal vTONGDATID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vTONGDATID", vTONGDATID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBYTONGDATID", parameters);
        }

        public DataTable ALD_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(decimal vTONGDATID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vTONGDATID", vTONGDATID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT_ANPHI.ALD_TONGDATDOITUONG_ANPHI_GETBYTONGDATID", parameters);
        }

        public DataTable ALD_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID(decimal? vDONID, decimal vANPHIID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vDONID", vDONID),
                new OracleParameter("vANPHIID", vANPHIID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT_ANPHI.ALD_TONGDATDOITUONG_ANPHI_GETBYANPHIID_TONGDATID", parameters);
        }

        public string ALD_TENBM_GETBYTONGDATID(decimal vTONGDATID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vTONGDATID", vTONGDATID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable dataTable = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_GETTENBM_BYTONGDATID", parameters);
            return dataTable.Rows[0][0].ToString(); 
        }

        public void ALD_TONGDAT_THUHOI(decimal vID, DateTime vNgayThuHoi, string vLyDo, string vNguoiSua)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_id", vID),
                new OracleParameter("vNgayThuHoi", vNgayThuHoi),
                new OracleParameter("vLyDo", vLyDo),
                new OracleParameter("vNguoiSua", vNguoiSua)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDAT_THUHOI", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters); 
            OracleTransaction transaction = connection.BeginTransaction();
            try
            {
                command.ExecuteNonQuery();
                transaction.Commit(); 
            }
            catch
            {
                transaction.Rollback(); 
            }
            finally
            {
                connection.Close();
            }
        }

        public void ALD_TONGDAT_THUHOI_DOITUONG(decimal vID, decimal tongDatID, string lyDoThuHoi, DateTime ngayThuHoi, string nguoiSua)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_DoiTuongTongDatId", vID),
                new OracleParameter("v_tongDatID", tongDatID),
                new OracleParameter("v_lyDoThuHoi", lyDoThuHoi),
                new OracleParameter("v_ngayThuHoi", ngayThuHoi),
                new OracleParameter("v_nguoiSua", nguoiSua)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDAT_THUHOI_DOITUONG", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters);
            OracleTransaction transaction = connection.BeginTransaction();
            try
            {
                command.ExecuteNonQuery();
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
            }
            finally
            {
                connection.Close();
            }
        }

        public void ALD_TONGDAT_VBDH_DOITUONG(decimal vID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_DoiTuongTongDatId", vID)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDAT_VBDH_DOITUONG", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters);
            OracleTransaction transaction = connection.BeginTransaction();
            try
            {
                command.ExecuteNonQuery();
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
            }
            finally
            {
                connection.Close();
            }
        }

        public string ALD_TONGDATDOITUONG_GETNAMEBYID(decimal vID , decimal vDUONGSUID)
        {
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETNAME", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vID" , vID) ,
                new OracleParameter("vDUONGSUID" , vDUONGSUID) , 
                new OracleParameter("curReturn" , OracleDbType.RefCursor , ParameterDirection.Output)
            };
            command.Parameters.AddRange(parameters);
            OracleDataAdapter dataAdapter = new OracleDataAdapter(command);
            DataTable table = new DataTable();
            dataAdapter.Fill(table);
            try
            {
                string Name = table.Rows[0][0] + "";
                return Name; 
            }
            catch
            {
                return null; 
            }
        }

        public DataTable ALD_TONGDAT_GETBYID(decimal vID)
        {   
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vID",vID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                                                      };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDAT_GETBYID", parameters);
        }

        public string GetTenTCTT_ById(string vID) {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vID" , vID) ,
                new OracleParameter("curReturn" , OracleDbType.RefCursor , ParameterDirection.Output) 
            };
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.GetTENTCTT_BYMA", Cls_Comon.OpenConnection());
            command.Parameters.AddRange(parameters);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            DataTable table = new DataTable();
            adapter.Fill(table);
            string result;
            try
            {
                result = table.Rows[0][0] + "";  
            }
            catch
            {
                result = ""; 
            }
            return result; 
        }

        public Decimal ALD_TONGDATDOITUONG_UPIN(BANGSETGET.ALD_TONGDAT_NGUOINHAN_GS NGUOINHAN)
        {
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDATNOINHAN_UP_IN", connection);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_id" ,  NGUOINHAN.ID),
                new OracleParameter("v_TONGDATID", NGUOINHAN.TONGDATID),
                new OracleParameter("v_MATUCACH", NGUOINHAN.MATUCACH),
                new OracleParameter("v_NGAYGUI", NGUOINHAN.NGAYGUI),
                new OracleParameter("v_TRANGTHAI", NGUOINHAN.TRANGTHAI),
                new OracleParameter("v_HINHTHUCGUI", NGUOINHAN.HINHTHUCGUI),
                new OracleParameter("v_DUONGSUID", NGUOINHAN.DUONGSUID),
                new OracleParameter("v_NGAYNHANTONGDAT", NGUOINHAN.NGAYNHANTONGDAT),
                new OracleParameter("v_QUOCGIA", NGUOINHAN.QUOCGIA),
                new OracleParameter("v_COQUAN", NGUOINHAN.COQUAN),
                new OracleParameter("v_NOIDUNG", NGUOINHAN.NOIDUNG),
                new OracleParameter("v_KETQUAUTTP", NGUOINHAN.KETQUAUTTP),
                new OracleParameter("v_NGAYPHATHANH", NGUOINHAN.NGAYPHATHANH),
                new OracleParameter("v_NGAYTAO", NGUOINHAN.NGAYTAO),
                new OracleParameter("v_NGUOITAO", NGUOINHAN.NGUOITAO),
                new OracleParameter("v_IS UTTP", NGUOINHAN.IS_UTTP),
                new OracleParameter("v_UTTP", NGUOINHAN.UTTP),
                new OracleParameter("v_NOINHAN", NGUOINHAN.NOINHAN),
                new OracleParameter("v_DIACHI", NGUOINHAN.DIACHI),
                new OracleParameter("v_TOA_GIAIQUYET_ID", NGUOINHAN.TOA_GIAIQUYET_ID),
                new OracleParameter("vID", OracleDbType.Decimal , ParameterDirection.Output)
            };
            command.CommandType = CommandType.StoredProcedure ;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters); 
            OracleTransaction transaction = connection.BeginTransaction();
            command.ExecuteNonQuery();
            transaction.Commit();
            connection.Close();
            //try
            //{
                return Convert.ToDecimal(command.Parameters["vID"].Value.ToString()); 
            //}
            //catch
            //{
            //    return -1; 
            //}
        }

        public string ALD_TONGDATDOITUONG_GETTENDUONGSU(decimal vID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vID" , vID) ,
                new OracleParameter("curReturn" , OracleDbType.RefCursor , ParameterDirection.Output)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters);
            command.CommandText = "PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETTENDUONGSU";
            command.Connection = connection;
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            var table = new DataTable();
            adapter.Fill(table);

            connection.Close();
            try
            {
                return table.Rows[0][0].ToString();
            }
            catch
            {
                return null;
            }
        }

        public Decimal ALD_TONGDAT_UPIN(BANGSETGET.ALD_TONGDAT_GS aLD_TONGDAT)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_TONGDAT.ALD_TONGDAT_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = aLD_TONGDAT.ID;
            comm.Parameters["v_DONID"].Value = aLD_TONGDAT.DONID;
            comm.Parameters["v_BIEUMAUID"].Value = aLD_TONGDAT.BIEUMAUID;
            comm.Parameters["v_TOAANID"].Value = aLD_TONGDAT.TOAANID;
            comm.Parameters["v_IS_TD_VKS"].Value = aLD_TONGDAT.IS_TD_VKS;
            comm.Parameters["v_IS_TD_VKS_NGAY"].Value = aLD_TONGDAT.IS_TD_VKS_NGAY;
            comm.Parameters["v_NGAYTAO"].Value = aLD_TONGDAT.NGAYTAO;
            comm.Parameters["v_NGUOITAO"].Value = aLD_TONGDAT.NGUOITAO;
            comm.Parameters["v_NGAYSUA"].Value = aLD_TONGDAT.NGAYSUA;
            comm.Parameters["v_NGUOISUA"].Value = aLD_TONGDAT.NGUOISUA;
            comm.Parameters["v_TENFILE"].Value = aLD_TONGDAT.TENFILE;
            comm.Parameters["v_KIEUFILE"].Value = aLD_TONGDAT.KIEUFILE;
            comm.Parameters["v_NOIDUNGFILE"].Value = aLD_TONGDAT.NOIDUNGFILE;
            comm.Parameters["v_FILEID"].Value = aLD_TONGDAT.FILEID;
            comm.Parameters["v_NGAYDANG_CTTDT"].Value = aLD_TONGDAT.NGAYDANG_CTTDT;
            comm.Parameters["v_NGAYNHANTONGDAT"].Value = aLD_TONGDAT.NGAYNHANTONGDAT;
            comm.Parameters["v_TRANGTHAI"].Value = aLD_TONGDAT.TRANGTHAI;
            comm.Parameters["v_NGAYTHUHOI"].Value = aLD_TONGDAT.NGAYTHUHOI;
            comm.Parameters["v_LYDOTHUHOI"].Value = aLD_TONGDAT.LYDOTHUHOI;
            comm.Parameters["v_URL_FILE"].Value = aLD_TONGDAT.URL_FILE;
            comm.Parameters["v_MAPID"].Value = aLD_TONGDAT.MAPID;
            comm.Parameters["v_MAP_TABLE"].Value = aLD_TONGDAT.MAP_TABLE;
            comm.Parameters["v_TOA_GIAIQUYET_ID"].Value = aLD_TONGDAT.TOA_GIAIQUYET_ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return Convert.ToDecimal(comm.Parameters["vID"].Value.ToString());
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return 0;
            }
            finally
            {
                conn.Close();
            }
        }
        
        public DataTable ALD_TONGDATDOITUONG_GETBYID(Decimal vID)
        {
            OracleParameter[] oracleParameter = new OracleParameter[]
            {
                new OracleParameter("vID" , vID) ,
                new OracleParameter("curReturn" , OracleDbType.RefCursor , ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBYID", oracleParameter);
        }

        public DataTable ALD_TONGDATDOITUONG_GETBYTONGDATDUONGSUID(Decimal tongDatID , Decimal? duongSuID)
        {
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand();
            command.Connection = connection;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.CommandText = "PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_GETBYTONGDATDUONGSUID";
            command.Parameters.AddRange(new OracleParameter[] {
                 new OracleParameter("vTONGDATID" , tongDatID),
                 new OracleParameter("vDUONGSUID" , duongSuID), 
                 new OracleParameter("curReturn" , OracleDbType.RefCursor , ParameterDirection.Output)
            });
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            connection.Close();
            return dataTable;
        }

        public Decimal ALD_TONGDATDOITUONG_REMOVEBYID(decimal vID)
        {
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand();
            command.Connection = connection;

            command.CommandText = "PKG_STPT_TONGDAT.ALD_TONGDATDOITUONG_REMOVEBYID";
            command.Parameters.Add(new OracleParameter("vID", vID));
            command.Parameters.Add(new OracleParameter("returnID" , OracleDbType.Decimal , ParameterDirection.Output));
            OracleTransaction transaction = connection.BeginTransaction();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.ExecuteNonQuery();
            transaction.Commit();
            connection.Close();
            return Convert.ToDecimal(command.Parameters["returnID"].Value.ToString());
        }
    }
}