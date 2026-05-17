using BL.GSTP.PCTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class PhanCongNgauNhien : System.Web.UI.Page
    {
        PCANN_BL pca = new PCANN_BL();
        DataTable tbl = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable check_pcdon = pca.PCANN_CHECK_TOA_PCDON(toa_an_id);
                if (check_pcdon.Rows.Count > 0)
                {
                    ddlgiaidoan.Enabled = false;
                }
                else
                {
                    ddlgiaidoan.Enabled = true;
                }
               
            }
            Load_Data();          
        }


        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            
            decimal giai_doan = Convert.ToInt32(ddlgiaidoan.SelectedValue);
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tu_ngay = txtTuNgay.Text.Trim();
            string den_ngay = txtDenNgay.Text.Trim();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
           
            tbl = pca.PCANN_DS_ANCHOPC(giai_doan, toa_an_id, tu_ngay, den_ngay);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int count_all = Convert.ToInt32(tbl.Rows.Count);               
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();

                if (dgList.CurrentPageIndex > (Convert.ToInt32(hddTotalPage.Value) - 1))
                {
                    dgList.CurrentPageIndex = 0;
                }
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        protected void lbphancong_Click(object sender, EventArgs e)
        {
            try
            {
                if (tbl.Rows.Count>0)
                {
                    decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string ten_can_bo = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    decimal id_can_bo = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
                    string rule_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    string ngaypc = DateTime.Now.ToString("yyyyMMdd");
                    decimal loai_pc = Convert.ToInt32(ddlgiaidoan.SelectedValue);

                    decimal id_ql_pca = 0;
                    id_ql_pca = pca.PCANN_LUU_QL_PCA(id_can_bo, ten_can_bo, ngaypc, toa_an_id);

                    for (int i = 0; i < tbl.Rows.Count; i++)
                    {
                        var id_vu_an = Convert.ToDecimal(tbl.Rows[i]["ID"]);
                        var loaian = tbl.Rows[i]["LOAIAN"].ToString();                                     
                        pca.PCANN_THEM_DSAN_DPC(id_vu_an, loaian, id_ql_pca, loai_pc);
                    }

                    for (int i = 0; i < tbl.Rows.Count; i++)
                    {
                        var id_vu_an = Convert.ToDecimal(tbl.Rows[i]["ID"]);
                        var loaian = tbl.Rows[i]["LOAIAN"].ToString();
                        var magiaidoan = Convert.ToDecimal(tbl.Rows[i]["MAGIAIDOAN"]);
                        var ten_vuan = tbl.Rows[i]["TENVUVIEC"].ToString();
                        var so_thuly = tbl.Rows[i]["SOTHULY"].ToString();
                        var ngay_thuly = tbl.Rows[i]["NGAYTHULY"].ToString();                      
                        pca.PCANN_PHANCONGTHAMPHAN(ngaypc, id_vu_an, loaian, toa_an_id, magiaidoan, ten_vuan, id_ql_pca, so_thuly, ngay_thuly, rule_id);
                    }

                    txtthongbao.Text = "Phân công án thành công!";
                    pca.PCANN_XOA_DS_AN_DANGPC(id_ql_pca);
                    pca.PCANN_DONGBO(id_ql_pca);
                    Load_Data();
                }
                else
                {
                    txtthongbao.Text = "Không có án để phân công!";
                }
                
            }
            catch (Exception ex)
            {
                txtthongbao.Text = "Phân công án thất bại!";

            }
           
           
        }

        protected void ddlgiaidoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            Load_Data();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = Convert.ToInt32(dropPageSize.SelectedValue);
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = Convert.ToInt32(dropPageSize2.SelectedValue);
            hddPageIndex.Value = "1";
            Load_Data();
        }
        //protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
        //        HiddenField hddMAGIAIDOAN = (HiddenField)e.Item.FindControl("hddMAGIAIDOAN");
        //        if (hddMAGIAIDOAN.Value == "1")
        //        {
        //            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
        //        }
        //        else
        //        {
        //            lbtXoa.Visible = false;
        //        }
        //        string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //        if (Session[ENUM_SESSION.SESSION_NHOMNSDID]+""=="1")
        //        {
        //            lbtXoa.Visible = true;
        //        }
        //    }
        //}

        //protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        //{
        //    decimal IDVuAn = Convert.ToDecimal(e.CommandArgument.ToString());
        //    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //    switch (e.CommandName)
        //    {
        //        case "Select":
        //            //Lưu vào người dùng
        //            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
        //            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
        //            if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
        //            {
        //                oNSD.IDAHINHSU = IDVuAn;
        //                dt.SaveChanges();
        //            }
        //            Session[ENUM_LOAIAN.AN_HINHSU] = IDVuAn;
        //            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //            //AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == IDVuAn).FirstOrDefault();
        //            //if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
        //            //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ án đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //            //else
        //            //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Bạn đã chọn vụ án, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //            break;
        //        case "Sua":
        //            Response.Redirect("thongtinan.aspx?type=list&ID=" + IDVuAn);
        //            break;
        //        case "Xoa":
        //            if (oPer.XOA == false)
        //            {
        //                lbtthongbao.Text = "Bạn không có quyền xóa!";
        //                //  Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
        //                return;
        //            }
        //            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //            if (Session[ENUM_SESSION.SESSION_NHOMNSDID]+""=="1")
        //            {
        //                AHS_VUAN_BL oBL = new AHS_VUAN_BL();
        //                if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuAn + "") == false)
        //                {
        //                    lbtthongbao.Text = "Lỗi khi xóa toàn bộ thông tin vụ việc !";
        //                    break;
        //                }
        //            }
        //            else
        //                XoaVuAn(IDVuAn);

        //            dgList.CurrentPageIndex = 0;
        //            hddPageIndex.Value = "1";
        //            Load_Data();
        //            break;
        //    }
        //}




        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

    }
}