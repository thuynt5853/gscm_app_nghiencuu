using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class SuaNgoaiTA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        List<DM_HANHCHINH> lstTinh;
        DataTable dtToaAn;
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                    Load_Data();
            }
        }
        private DataTable getDS()
        {
            decimal isDonGoc = 1;
            if ((Session[SS_TK.ISDONGOC] + "") == "0") isDonGoc = 0;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = 0, HinhThucDon = 0, DiaChiTinh = 0, DiaChiHuyen = 0, TraLoi = 0, vNoichuyen = 0, vTrangthai = 0, vCD_DONVIID = 0, vCD_TA_TRANGTHAI = 0, vIsThuLy = 0, vPhanloaixuly = 0;
            string SoBAQD, NgayBAQD, NguoiGui, SoCMND, SoHieuDon, DiaChiCT, SoCongVan, NgayCongVan, strNguoiNhap = "", vArrSelectID = "", vCD_TENDONVI;
            DateTime? TuNgay, DenNgay, vNgaychuyenTu, vNgaychuyenDen, vNgayThulyTu, vNgayThulyDen, vNgayNhapTu, vNgayNhapDen;
            string vSoThuly;
            decimal vChidao = 0, vLoaiAn = 0, vTraigiam = 0, vTBQuahan = 0, vThamphanID = 0, vThamtravienID = 0, vLoaiCVID = 0, vIsTuHinh = 0;
            NguoiGui = Session[SS_TK.NGUOIGUI] + "";
            SoBAQD = Session[SS_TK.SOBAQD] + "";
            NgayBAQD = Session[SS_TK.NGAYBAQD] + "";
            if (Session[SS_TK.TOAANXX] != null) ToaRaBAQD = Convert.ToDecimal(Session[SS_TK.TOAANXX]);
            TuNgay = (Session[SS_TK.NGAYNHANTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            DenNgay = (Session[SS_TK.NGAYNHANDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session[SS_TK.LOAICHUYEN] != null) vNoichuyen = Convert.ToDecimal(Session[SS_TK.LOAICHUYEN]);
            if (Session[SS_TK.PHONGBANCHUYEN] != null) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.PHONGBANCHUYEN]);
            if (Session[SS_TK.DIEUKIENCHUYEN] != null) vCD_TA_TRANGTHAI = Convert.ToDecimal(Session[SS_TK.DIEUKIENCHUYEN]);
            vNgaychuyenTu = (Session[SS_TK.NGAYCHUYENTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgaychuyenDen = (Session[SS_TK.NGAYCHUYENDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session[SS_TK.TOAKHACID] != null && vNoichuyen > 0) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.TOAKHACID]);
            vCD_TENDONVI = Session[SS_TK.TENNGOAITOAAN] + "";
            if (Session[SS_TK.THULYDON] != null) vIsThuLy = Convert.ToDecimal(Session[SS_TK.THULYDON]);
            if (Session[SS_TK.HINHTHUCDON] != null) HinhThucDon = Convert.ToDecimal(Session[SS_TK.HINHTHUCDON]);
            SoCMND = Session[SS_TK.SOCMND] + "";
            SoHieuDon = Session[SS_TK.MADON] + "";
            if (Session[SS_TK.TINHID] != null) DiaChiTinh = Convert.ToDecimal(Session[SS_TK.TINHID]);
            if (Session[SS_TK.HUYENID] != null) DiaChiHuyen = Convert.ToDecimal(Session[SS_TK.HUYENID]);
            DiaChiCT = Session[SS_TK.DIACHICHITIET] + "";
            if (Session[SS_TK.TRALOIDON] != null) TraLoi = Convert.ToDecimal(Session[SS_TK.TRALOIDON]);
            SoCongVan = Session[SS_TK.SOCV] + "";
            NgayCongVan = Session[SS_TK.NGAYCV] + "";
            if (Session[SS_TK.TRANGTHAICHUYEN] != null) vTrangthai = Convert.ToDecimal(Session[SS_TK.TRANGTHAICHUYEN]);

            vNgayThulyTu = (Session[SS_TK.THULY_TU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_TU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayThulyDen = (Session[SS_TK.THULY_DEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_DEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);

            vNgayNhapTu = (Session[SS_TK.NGAYNHAPTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHAPTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgayNhapDen = (Session[SS_TK.NGAYNHAPDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHAPDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vSoThuly = Session[SS_TK.SOTHULY] + "";
            if (Session[SS_TK.CHANHANCHIDAO] != null) vChidao = Convert.ToDecimal(Session[SS_TK.CHANHANCHIDAO]);
            if (Session[SS_TK.TRAIGIAM] != null) vTraigiam = Convert.ToDecimal(Session[SS_TK.TRAIGIAM]);
            if (Session[SS_TK.THAMPHAN] != null) vThamphanID = Convert.ToDecimal(Session[SS_TK.THAMPHAN]);
            if (Session[SS_TK.LOAICV] != null) vLoaiCVID = Convert.ToDecimal(Session[SS_TK.LOAICV]);
            if (Session[SS_TK.LOAIAN] != null) vLoaiAn = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            vArrSelectID = Session[SS_TK.ARRSELECTID] + "";
            strNguoiNhap = Session[SS_TK.NGUOINHAP] + "";
            if (Session[SS_TK.ISTUHINH] != null) vIsTuHinh = Convert.ToDecimal(Session[SS_TK.ISTUHINH]);
            string vCVPC_So = Session[SS_TK.CVPC_SO] + "", vCVPC_Ngay = Session[SS_TK.CVPC_NGAY] + "", vCVPC_TenCQ = Session[SS_TK.CVPC_TenCQ] + "";
            decimal vGuitoiCA_TA = -1;
            if (Session[SS_TK.GUITOI_CA_TA] != null) vGuitoiCA_TA = Convert.ToDecimal(Session[SS_TK.GUITOI_CA_TA]);

            DataTable oDT = oBL.GDTTT_DON_SUA_SEARCH(ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                   SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                   DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                   vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                   , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vThamphanID
                   , vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA);
            return oDT;
        }
        private void Load_Data()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == 0).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            dtToaAn = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            DataTable oDT = getDS();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            if (dgList.PageCount <= 1)
            {
                cmdLuuAndNext.Visible = false;
                cmdLuu.Text = "Lưu danh sách";
            }
            else
                cmdLuu.Text = "Lưu";
        }

        private void SaveData()
        {
            foreach (DataGridItem item in dgList.Items)
            {
                string strID = item.Cells[0].Text;
                decimal ID = Convert.ToDecimal(strID);
                GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();

                TextBox txtNgaynhandon = (TextBox)item.FindControl("txtNgaynhandon");
                TextBox txtNguoigui = (TextBox)item.FindControl("txtNguoigui");
                DropDownList ddlDonvigui = (DropDownList)item.FindControl("ddlDonvigui");
                DropDownList ddlTinh = (DropDownList)item.FindControl("ddlTinh");
                DropDownList ddlHuyen = (DropDownList)item.FindControl("ddlHuyen");
                TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                TextBox txtSoBAQD = (TextBox)item.FindControl("txtSoBAQD");
                TextBox txtNgayBAQD = (TextBox)item.FindControl("txtNgayBAQD");
                DropDownList ddlToaXX = (DropDownList)item.FindControl("ddlToaXX");
                TextBox txtNoichuyen = (TextBox)item.FindControl("txtNoichuyen");
                TextBox txtGhichu = (TextBox)item.FindControl("txtGhichu");

                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgaynhandon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgayBAQD = (String.IsNullOrEmpty(txtNgayBAQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayBAQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                

                if (dNgayNhan != DateTime.MinValue) obj.NGAYNHANDON = dNgayNhan;

                if (obj.LOAIDON == 2 || obj.LOAIDON == 6 || obj.LOAIDON == 9)
                {
                    if (obj.CV_ISTRONGNGANH == 0)
                    {
                        obj.CV_TENDONVI = txtNguoigui.Text;
                    }
                    else if (obj.CV_ISTRONGNGANH == 1)
                    {
                        obj.CV_TOAANID = Convert.ToDecimal(ddlDonvigui.SelectedValue);
                    }

                    obj.CV_TINHID = obj.NGUOIGUI_TINHID;
                    obj.CV_HUYENID = obj.NGUOIGUI_HUYENID;
                    obj.CV_DIACHI = txtDiachi.Text;
                }
                else
                {
                    obj.NGUOIGUI_HOTEN = txtNguoigui.Text;
                    if (obj.DONGKHIEUNAI.Contains(obj.NGUOIGUI_HOTEN))
                    {
                        obj.DONGKHIEUNAI.Replace(obj.NGUOIGUI_HOTEN, txtNguoigui.Text);
                    }

                    obj.NGUOIGUI_TINHID = Convert.ToDecimal(ddlTinh.SelectedValue); ;
                    obj.NGUOIGUI_HUYENID = Convert.ToDecimal(ddlHuyen.SelectedValue);
                    obj.NGUOIGUI_DIACHI = txtDiachi.Text;
                }

                if (obj.BAQD_CAPXETXU == 2)
                {
                    obj.BAQD_SO_ST = txtSoBAQD.Text;
                    obj.BAQD_NGAYBA_ST = dNgayBAQD != DateTime.MinValue ? dNgayBAQD : (DateTime?)null;
                    obj.BAQD_TOAANID_ST = Convert.ToDecimal(ddlToaXX.SelectedValue);
                }
                else if (obj.BAQD_CAPXETXU == 3)
                {
                    obj.BAQD_SO_PT = txtSoBAQD.Text;
                    obj.BAQD_NGAYBA_PT = dNgayBAQD != DateTime.MinValue ? dNgayBAQD : (DateTime?)null;
                    obj.BAQD_TOAANID_PT = Convert.ToDecimal(ddlToaXX.SelectedValue);
                }
                else
                {
                    obj.BAQD_SO = txtSoBAQD.Text;
                    obj.BAQD_NGAYBA = dNgayBAQD != DateTime.MinValue ? dNgayBAQD : (DateTime?)null;
                    obj.BAQD_TOAANID = Convert.ToDecimal(ddlToaXX.SelectedValue);
                }

                obj.CD_NTA_TENDONVI = txtNoichuyen.Text;

                obj.GHICHU = txtGhichu.Text;
                dt.SaveChanges();
            }
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            SaveData();
            lbthongbao.Text = "Lưu thành công trang hiện tại !";
        }
        protected void cmdLuuAndNext_Click(object sender, EventArgs e)
        {
            SaveData();
            lbthongbao.Text = "Lưu thành công trang hiện tại và chuyển sang trang tiếp !";
            if (dgList.CurrentPageIndex != dgList.PageCount - 1)
            {
                dgList.CurrentPageIndex = dgList.CurrentPageIndex + 1;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            else
                lbthongbao.Text = "Lưu thành công trang hiện tại !";
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    HiddenField hddLoaidon = (HiddenField)e.Item.FindControl("hddLoaidon");

                    DropDownList ddlTinh = (DropDownList)e.Item.FindControl("ddlTinh");
                    DropDownList ddlHuyen = (DropDownList)e.Item.FindControl("ddlHuyen");
                    HiddenField hddCV_ISTRONGNGANH = (HiddenField)e.Item.FindControl("hddCV_ISTRONGNGANH");
                    HiddenField hddTinhID = (HiddenField)e.Item.FindControl("hddTinhID");
                    HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                    
                    TextBox txtNguoigui = (TextBox)e.Item.FindControl("txtNguoigui");
                    DropDownList ddlDonvigui = (DropDownList)e.Item.FindControl("ddlDonvigui");

                    ddlTinh.ToolTip = e.Item.Cells[0].Text;
                    ddlTinh.DataSource = lstTinh;
                    ddlTinh.DataTextField = "TEN";
                    ddlTinh.DataValueField = "ID";
                    ddlTinh.DataBind();
                    ddlTinh.Items.Insert(0, new ListItem("--", "0"));
                    if (hddHuyenID.Value != "" && hddHuyenID.Value != "0")
                    {
                        decimal HuyenID = Convert.ToDecimal(hddHuyenID.Value);
                        DM_HANHCHINH oHC = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault();
                        if (oHC.LOAI == 2)//Huyện
                        {
                            ddlTinh.SelectedValue = oHC.CAPCHAID.ToString();
                            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == oHC.CAPCHAID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                            ddlHuyen.DataSource = lstHuyen;
                            ddlHuyen.DataTextField = "TEN";
                            ddlHuyen.DataValueField = "ID";
                            ddlHuyen.DataBind();
                            ddlHuyen.SelectedValue = oHC.ID.ToString();
                        }
                        else//TỈnh
                        {
                            ddlTinh.SelectedValue = oHC.ID.ToString();
                            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == oHC.ID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                            ddlHuyen.DataSource = lstHuyen;
                            ddlHuyen.DataTextField = "TEN";
                            ddlHuyen.DataValueField = "ID";
                            ddlHuyen.DataBind();
                            ddlHuyen.Items.Insert(0, new ListItem("--", "0"));
                        }
                    }
                    else
                    {
                        ddlHuyen.Items.Insert(0, new ListItem("--", "0"));
                    }

                    DropDownList ddlToaXX = (DropDownList)e.Item.FindControl("ddlToaXX");
                    ddlToaXX.DataSource = dtToaAn;
                    ddlToaXX.DataTextField = "MA_TEN";
                    ddlToaXX.DataValueField = "ID";
                    ddlToaXX.DataBind();
                    ddlToaXX.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

                    HiddenField hddToaXXID = (HiddenField)e.Item.FindControl("hddToaXXID");
                    string toaid = hddToaXXID.Value + "";
                    if (toaid != "" && toaid != "0")
                        ddlToaXX.SelectedValue = toaid;

                    if (hddLoaidon.Value == "2" || hddLoaidon.Value == "6" || hddLoaidon.Value == "9")
                    {
                        if (hddCV_ISTRONGNGANH.Value == "1")
                        {
                            HiddenField hddNGUOIGUI_HOTEN = (HiddenField)e.Item.FindControl("HddNGUOIGUI_HOTEN");
                            txtNguoigui.Visible = false;
                            ddlDonvigui.Visible = true;

                            ddlDonvigui.DataSource = dtToaAn;
                            ddlDonvigui.DataTextField = "MA_TEN";
                            ddlDonvigui.DataValueField = "ID";
                            ddlDonvigui.DataBind();
                            ddlDonvigui.SelectedValue = hddNGUOIGUI_HOTEN.Value;
                        }
                        else
                        {
                            txtNguoigui.Visible = true;
                            ddlDonvigui.Visible = false;
                        }
                    }
                    else
                    {
                        txtNguoigui.Visible = true;
                        ddlDonvigui.Visible = false;
                    }

                }
                catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
                {
                    foreach (var validationErrors in dbEx.EntityValidationErrors)
                    {
                        foreach (var validationError in validationErrors.ValidationErrors)
                        {
                            string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                        }
                    }
                }
            }
        }

        protected void ddlTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            string ID = ddl.ToolTip;
            foreach (DataGridItem obj in dgList.Items)
            {
                DropDownList ddlTinh = (DropDownList)obj.FindControl("ddlTinh");
                if (ddlTinh.ToolTip == ID)
                {
                    DropDownList ddlHuyen = (DropDownList)obj.FindControl("ddlHuyen");
                    decimal IDTinh = Convert.ToDecimal(ddlTinh.SelectedValue);
                    List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == IDTinh).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                    ddlHuyen.DataSource = lstHuyen;
                    ddlHuyen.DataTextField = "TEN";
                    ddlHuyen.DataValueField = "ID";
                    ddlHuyen.DataBind();
                    ddlHuyen.Items.Insert(0, new ListItem("--", "0"));
                    return;
                }
            }
        }

        #region "Phân trang"

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

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
    }
}