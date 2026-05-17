using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.HoSo
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3, LUUTAM = 1, DAGUI = 2, TRALAI = 3, HOANTAT = 4;
        private const string VUTDKT_TANDTC = "1", DONVIKHAC = "0";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                else
                {
                    decimal UserID = Convert.ToDecimal(strUserID);
                    if (Check_Vu_TDKT_TANDTC_Login(UserID))
                    {
                        HdfVuTDKT.Value = VUTDKT_TANDTC;// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
                        BtnThemMoi.Visible = false;
                    }
                    else
                    {
                        HdfVuTDKT.Value = DONVIKHAC;
                        BtnThemMoi.Visible = true;
                    }
                }
                if (!IsPostBack)
                {
                    LoadDropDonVi();
                    LoadDropTrangThai();
                    if (Request["pag"] + "" != "")
                    {
                        int PageIndex = 0;
                        if (int.TryParse(Request["pag"] + "", out PageIndex))
                        {
                            hddPageIndex.Value = PageIndex.ToString();
                        }
                        else
                        {
                            hddPageIndex.Value = "1";
                        }
                    }
                    else
                    {
                        hddPageIndex.Value = "1";
                    }
                    LoadData();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi()
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            string LoaiToa = "";
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
            if (ObjTA != null)
            {
                LoaiToa = ObjTA.LOAITOA;
            }
            if (LoaiToa == "TOICAO")
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropToaAn.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            if (Request["dv"] + "" != "")
            {
                try { DropToaAn.SelectedValue = Request["dv"] + ""; } catch { }
            }
        }
        private void LoadDropTrangThai()
        {
            DropTrangThai.Items.Add(new ListItem("--- Chọn ---", "0"));
            if (HdfVuTDKT.Value == VUTDKT_TANDTC)// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
            {
                DropTrangThai.Items.Add(new ListItem("Đang thẩm định", "2"));
                DropTrangThai.Items.Add(new ListItem("Đã hoàn tất", "4"));
            }
            else
            {
                DropTrangThai.Items.Add(new ListItem("Lưu tạm", "1"));
                DropTrangThai.Items.Add(new ListItem("Đã gửi trình", "2"));
                DropTrangThai.Items.Add(new ListItem("Bị trả lại", "3"));
            }
        }
        private void LoadData()
        {
            Lblthongbao.Text = "";
            decimal ToaAnID = Convert.ToDecimal(DropToaAn.SelectedValue),
                    IsVuTDKT_Login = Convert.ToDecimal(HdfVuTDKT.Value),
                    TrangThai = Convert.ToDecimal(DropTrangThai.SelectedValue);
            string Ma = TxtMa.Text.Trim().ToLower(),
                   Ten = TxtTen.Text.Trim().ToLower();
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_TOAANID",ToaAnID),
                new OracleParameter("IN_VU_TDKT",IsVuTDKT_Login),
                new OracleParameter("IN_MA",Ma),
                new OracleParameter("IN_TEN",Ten),
                new OracleParameter("IN_TRANG_THAI",TrangThai),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_HOSO_GETDATA", parameters);
            if (tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,0.###", cul)
                                                        + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                PnlData.Visible = true;
            }
            else
            {
                PnlData.Visible = false;
            }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
            if (HdfVuTDKT.Value == VUTDKT_TANDTC)// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
            {
                dgList.Columns[8].Visible = true;// Cột thời gian thẩm định còn lại
            }
            else
            {
                dgList.Columns[9].Visible = false;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split(';');
            decimal ID = Convert.ToDecimal(arr[0])
                    , Danh_Sach_ID = Convert.ToDecimal(arr[1]);
            string Link = "";
            switch (e.CommandName)
            {
                case "ToTrinh":
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Totrinh.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "BienBanHop":
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Bienbanhop.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "BienBanKiemPhieu":
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Bienbankiemphieu.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "BaoCao":
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Baocao.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "DanhSachFile":
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Danhsachfile.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "Gui":
                    TDKT_HO_SO Obj = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
                    if (Obj != null)
                    {
                        Obj.TRANGTHAI = DAGUI;
                        Obj.NGAY_GUI_TRINH = DateTime.Now;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    LoadData();
                    Lblthongbao.Text = "Gửi Vụ Thi đua - Khen thưởng Tòa án nhân dân thành công.";
                    break;
                case "HoanTat":
                    TDKT_HO_SO ObjHoanTat = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
                    if (ObjHoanTat != null)
                    {
                        ObjHoanTat.TRANGTHAI = HOANTAT;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    LoadData();
                    Lblthongbao.Text = "Hồ sơ đã được hoàn tất.";
                    break;
                case "TraLai":
                    TDKT_HO_SO ObjHoSo = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
                    if (ObjHoSo != null)
                    {
                        ObjHoSo.TRANGTHAI = TRALAI;
                        ObjHoSo.NGAY_GUI_TRINH = (DateTime?)null;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    LoadData();
                    Lblthongbao.Text = "Trả lại hồ sơ cho đơn vị trình thành công.";
                    break;
                case "Sua":
                    hddID.Value = ID.ToString();
                    Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Edit.aspx?hso=" + ID + "&dv=" + DropToaAn.SelectedValue + "&ds=" + Danh_Sach_ID.ToString() + "&pag=" + hddPageIndex.Value;
                    Response.Redirect(Link);
                    break;
                case "Xoa":
                    if (IsExistsData(ID))
                    {
                        return;
                    }
                    Xoa(ID);
                    hddPageIndex.Value = "1";
                    LoadData();
                    Lblthongbao.Text = "Xóa thành công.";
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView r = (DataRowView)e.Item.DataItem;
                LinkButton LbtGuiVuTDKT = (LinkButton)e.Item.FindControl("LbtGuiVuTDKT");
                LinkButton LbtHoanTat = (LinkButton)e.Item.FindControl("LbtHoanTat");
                LinkButton LbtTraLai = (LinkButton)e.Item.FindControl("LbtTraLai");
                LinkButton LbtSua = (LinkButton)e.Item.FindControl("LbtSua");
                LinkButton LbtXoa = (LinkButton)e.Item.FindControl("LbtXoa");
                HyperLink lkSpace_Vu_TDKT = (HyperLink)e.Item.FindControl("lkSpace_Vu_TDKT");
                HyperLink lkSpace_GuiTrinh = (HyperLink)e.Item.FindControl("lkSpace_GuiTrinh");
                HyperLink lkSpace = (HyperLink)e.Item.FindControl("lkSpace");
                LbtGuiVuTDKT.Visible = LbtSua.Visible = LbtXoa.Visible = LbtTraLai.Visible = lkSpace_Vu_TDKT.Visible = lkSpace.Visible = true;
                decimal TrangThai = Convert.ToDecimal(r["TRANGTHAI"]);
                if (HdfVuTDKT.Value == VUTDKT_TANDTC)// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
                {
                    LbtSua.Text = "Chi tiết"; LbtSua.ToolTip = "Chi tiết";
                    LbtGuiVuTDKT.Visible = LbtXoa.Visible = lkSpace.Visible = false;
                    if (TrangThai == HOANTAT)
                    {
                        LbtHoanTat.Visible = LbtTraLai.Visible = lkSpace_Vu_TDKT.Visible = lkSpace_GuiTrinh.Visible = false;
                    }
                }
                else
                {
                    LbtHoanTat.Visible = LbtTraLai.Visible = lkSpace_Vu_TDKT.Visible = lkSpace_GuiTrinh.Visible = false;
                    if (TrangThai == DAGUI || TrangThai == HOANTAT)
                    {
                        LbtSua.Text = "Chi tiết"; LbtSua.ToolTip = "Chi tiết";
                        LbtGuiVuTDKT.Visible = LbtXoa.Visible = lkSpace.Visible = false;
                    }
                }
            }
        }
        private void Xoa(decimal ID)
        {
            TDKT_HO_SO Obj = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
            if (Obj != null)
            {
                dt.TDKT_HO_SO.Remove(Obj);
                dt.SaveChanges();
            }
        }
        private void ResetData()
        {
            DropToaAn.SelectedIndex = 0;
            TxtMa.Text = "";
            TxtTen.Text = "";
            Lblthongbao.Text = "";
        }
        protected void BtnThemMoi_Click(object sender, EventArgs e)
        {
            string Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Edit.aspx?dv=" + DropToaAn.SelectedValue + "&pag=" + hddPageIndex.Value;
            Response.Redirect(Link);
        }
        protected void BtnTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
        private bool IsExistsData(decimal ID)
        {
            TDKT_HO_SO_TO_TRINH Obj = dt.TDKT_HO_SO_TO_TRINH.Where(x => x.HO_SO_ID == ID).FirstOrDefault();
            if (Obj != null)
            {
                Lblthongbao.Text = "Đã có tờ trình trong hồ sơ. Không được xóa.";
                return true;
            }
            return false;
        }
        private bool Check_Vu_TDKT_TANDTC_Login(decimal UserID)
        {
            QT_NGUOISUDUNG ObjUser = dt.QT_NGUOISUDUNG.Where(x => x.ID == UserID).FirstOrDefault();
            if (ObjUser != null)
            {
                QT_NHOMNGUOIDUNG NhomVuTDKT = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == ObjUser.NHOMNSDID).FirstOrDefault();
                if (NhomVuTDKT != null)
                {
                    if (NhomVuTDKT.TEN == "Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao")
                    {
                        return true;
                    }
                }
            }
            return false;
        }
    }
}