using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Text;

namespace BL.GSTP
{
    public class TongHop_BL
    {
        public DataTable GETVUVIEC_NHANAN(decimal vToaAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.GETVUVIEC_NHANAN", parameters);
            return tbl;
        }

        public DataTable DS_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vDonan)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            if (vDonan == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("vDonan",vDonan),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.DS_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.DS_NHANDON", parameters);
                return tbl;
            }
        }

        public DataTable DS_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vDonan)
        {
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vDonan == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("vDonan",vDonan),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.DS_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.DS_CHUYENDON", parameters);
                return tbl;
            }
        }

        public DataTable HC_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vIsAn = 1)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HC_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHC_GS.HC_NHANDON", parameters);
                return tbl;
            }
        }

        public DataTable HC_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vIsAn = 1)
        {
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HC_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHC_GS.HC_CHUYENDON", parameters);
                return tbl;
            }
        }

        public DataTable HN_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vIsAn = 1)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HN_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.HN_NHANDON", parameters);
                return tbl;
            }
        }

        public DataTable HN_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vIsAn = 1)
        {
            //OracleParameter[] parameters = new OracleParameter[] {
            //                                                            new OracleParameter("vToaAnID",vToaAnID),
            //                                                             new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
            //                                                            new OracleParameter("vMavuviec",vMavuviec),
            //                                                            new OracleParameter("vTenvuviec",vTenvuviec),
            //                                                            new OracleParameter("vSoQD",vSoQD),
            //                                                            new OracleParameter("vSoBA",vSoBA),
            //                                                            new OracleParameter("vTungay",vTungay),
            //                                                            new OracleParameter("vDenngay",vDenngay),
            //                                                             new OracleParameter("vDuongsu",vDuongsu),
            //                                                            new OracleParameter("vTrangthai",vTrangthai),
            //                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            //                                                          };
            //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HN_CHUYENAN", parameters);
            //return tbl;
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HN_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.HN_CHUYENDON", parameters);
                return tbl;
            }
        }

        public DataTable KT_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vIsAn = 1)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vToachuyen = vToachuyen.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_NG_KC", V_NG_KC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vToachuyen",vToachuyen),
                new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_so_qd", v_so_qd),
                new OracleParameter("v_ngay_qd", v_ngay_qd),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.KT_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_NG_KC", V_NG_KC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vToachuyen",vToachuyen),
                new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_so_qd", v_so_qd),
                new OracleParameter("v_ngay_qd", v_ngay_qd),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AKT_GS.KT_NHANDON", parameters);
                return tbl;
            }
        }

        public DataTable KT_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vIsAn = 1)
        {
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.KT_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AKT_GS.KT_CHUYENDON", parameters);
                return tbl;
            }
        }

        public DataTable LD_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vIsAn = 1)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.LD_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_NG_KC", V_NG_KC),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vMavuviec",vMavuviec),
            new OracleParameter("vTenvuviec",vTenvuviec),
            new OracleParameter("vToachuyen",vToachuyen),
            new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
            new OracleParameter("vTungay",vTungay),
            new OracleParameter("vDenngay",vDenngay),
            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ALD_GS.LD_NHANDON", parameters);
                return tbl;
            }
        }

        public DataTable LD_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vIsAn = 1)
        {
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.LD_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ALD_GS.LD_CHUYENDON", parameters);
                return tbl;
            }
        }

        //public DataTable PS_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //        new OracleParameter("V_NG_KC", V_NG_KC),
        //        new OracleParameter("vToaAnID",vToaAnID),
        //        new OracleParameter("vMavuviec",vMavuviec),
        //        new OracleParameter("vTenvuviec",vTenvuviec),
        //        new OracleParameter("vToachuyen",vToachuyen),
        //        new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
        //        new OracleParameter("vTungay",vTungay),
        //        new OracleParameter("vDenngay",vDenngay),
        //        new OracleParameter("vTrangthai",vTrangthai),
        //        new OracleParameter("v_so_qd", v_so_qd),
        //        new OracleParameter("v_ngay_qd", v_ngay_qd),
        //        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.PS_NHANAN", parameters);
        //    return tbl;
        //}

        public DataTable PS_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai, decimal vIsAn = 1)
        {
            V_NG_KC = V_NG_KC.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_NG_KC", V_NG_KC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vToachuyen",vToachuyen),
                new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_so_qd", v_so_qd),
                new OracleParameter("v_ngay_qd", v_ngay_qd),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.PS_NHANAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_NG_KC", V_NG_KC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vToachuyen",vToachuyen),
                new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_so_qd", v_so_qd),
                new OracleParameter("v_ngay_qd", v_ngay_qd),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APS_GS.PS_NHANDON", parameters);
                return tbl;
            }
        }

        //public DataTable PS_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                                new OracleParameter("vToaAnID",vToaAnID),
        //                                                                 new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
        //                                                                new OracleParameter("vMavuviec",vMavuviec),
        //                                                                new OracleParameter("vTenvuviec",vTenvuviec),
        //                                                                new OracleParameter("vSoQD",vSoQD),
        //                                                                new OracleParameter("vSoBA",vSoBA),
        //                                                                new OracleParameter("vTungay",vTungay),
        //                                                                new OracleParameter("vDenngay",vDenngay),
        //                                                                 new OracleParameter("vDuongsu",vDuongsu),
        //                                                                new OracleParameter("vTrangthai",vTrangthai),
        //                                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.PS_CHUYENAN", parameters);
        //    return tbl;
        //}
        public DataTable PS_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai, decimal vIsAn = 1)
        {
            vToaAnNhan_ten = vToaAnNhan_ten.Normalize(NormalizationForm.FormC);
            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            vTenvuviec = vTenvuviec.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vSoBA = vSoBA.Normalize(NormalizationForm.FormC);
            vDuongsu = vDuongsu.Normalize(NormalizationForm.FormC);
            if (vIsAn == 1)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.PS_CHUYENAN", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APS_GS.PS_CHUYENDON", parameters);
                return tbl;
            }
        }

        public DataTable XLHC_NHANAN(string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vToachuyen",vToachuyen),
                                                                        new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_NHANAN", parameters);
            return tbl;
        }

        public DataTable XLHC_NHANAN_V2(string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vToachuyen",vToachuyen),
                                                                        new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("v_so_qd", v_so_qd),
            new OracleParameter("v_ngay_qd", v_ngay_qd),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_NHANAN_V2", parameters);
            return tbl;
        }
        
        public DataTable XLHC_NHANAN_V3(string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vToachuyen",vToachuyen),
                new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_so_qd", v_so_qd),
                new OracleParameter("v_ngay_qd", v_ngay_qd),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_NHANAN_V3", parameters);
            return tbl;
        }

        public DataTable XLHC_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_CHUYENAN", parameters);
            return tbl;
        }

        public DataTable XLHC_CHUYENAN_V2(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_CHUYENAN_V2", parameters);
            return tbl;
        }
        
        public DataTable XLHC_CHUYENAN_V3(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                new OracleParameter("vMavuviec",vMavuviec),
                new OracleParameter("vTenvuviec",vTenvuviec),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vTungay",vTungay),
                new OracleParameter("vDenngay",vDenngay),
                new OracleParameter("vDuongsu",vDuongsu),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_CHUYENAN_V3", parameters);
            return tbl;
        }

        public DataTable XLHC_CHUYENAN_PHUCTHAM(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.XLHC_CHUYENAN_PHUCTHAM", parameters);
            return tbl;
        }

        public DataTable HS_NHANAN(string V_NG_KC, string v_so_qd, string v_ngay_qd, decimal vToaAnID, string vMavuviec, string vTenvuviec, string vToachuyen, decimal vTruongHopGiaoNhan, DateTime? vTungay, DateTime? vDenngay, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_NG_KC", V_NG_KC),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("vToaAnID",vToaAnID),
                        new OracleParameter("vMavuviec",vMavuviec),
                        new OracleParameter("vTenvuviec",vTenvuviec),
                        new OracleParameter("vToachuyen",vToachuyen),
                        new OracleParameter("vTruongHopGiaoNhan",vTruongHopGiaoNhan),
                        new OracleParameter("vTungay",vTungay),
                        new OracleParameter("vDenngay",vDenngay),
                        new OracleParameter("vTrangthai",vTrangthai),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                       };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HS_NHANAN", parameters);
            return tbl;
        }

        public DataTable HS_NHANAN_CHITIET(decimal V_VUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_VUANID",V_VUANID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                       };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HS_NHANAN_CHITIET", parameters);
            return tbl;
        }

        public DataTable HS_CHUYENAN_CHITIET(decimal V_VUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_VUANID",V_VUANID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                       };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HS_CHUYEN_AN_CHITIET", parameters);
            return tbl;
        }

        public DataTable HS_CHUYENAN(decimal vToaAnID, string vToaAnNhan_ten, string vMavuviec, string vTenvuviec, string vSoQD, string vSoBA, DateTime? vTungay, DateTime? vDenngay, string vDuongsu, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaAnNhan_ten",vToaAnNhan_ten),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vSoQD",vSoQD),
                                                                        new OracleParameter("vSoBA",vSoBA),
                                                                        new OracleParameter("vTungay",vTungay),
                                                                        new OracleParameter("vDenngay",vDenngay),
                                                                         new OracleParameter("vDuongsu",vDuongsu),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS_BC.HS_CHUYENAN", parameters);
            return tbl;
        }

        public DataTable THONGKE_STPT_CHANH_AN(decimal vToaAnID, DateTime? vFromDate, DateTime? vToDate)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vFromDate",vFromDate),
                                                                        new OracleParameter("vToDate",vToDate),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THONGKE_STPT_CHANH_AN", parameters);
            return tbl;
        }

        public DataTable TRANGCHU_THAMPHAN(decimal vToaAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_TOAANID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TRANGCHU_THAMPHAN", parameters);
            return tbl;
        }
    }
}