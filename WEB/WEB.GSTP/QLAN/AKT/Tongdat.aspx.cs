using BL.GSTP;
using DAL.GSTP;
using DAL.DKK;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.TONGDAT_DTO;
using System.Net;
using System.Configuration;
using Newtonsoft.Json;
using System.Text;
using BL.GSTP.TP_THADS;
using BL.GSTP.AKT;
using BL.GSTP.TONGDAT;
using Newtonsoft.Json.Linq;
using BL.GSTP.BANGSETGET;

using System.IO;
using Module.Common.Auth;
using BL.GSTP.ADS;

namespace WEB.GSTP.QLAN.AKT
{
    public partial class Tongdat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        DKKContextContainer dkk = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        AKT_TONGDAT_BL TONGDAT_BL = new AKT_TONGDAT_BL();

        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }

        public string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch { return ""; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "", TOAANID = "0";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadGrid();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                decimal ID = Convert.ToDecimal(current_id), HinhThucNHanDon = 0, MAGIAIDOAN = 0;
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
                hddarrDuongsuTructuyen.Value = "";
                bool isTructuyen = false;
                if (oT != null)
                {
                    HinhThucNHanDon = oT.HINHTHUCNHANDON + "" == "" ? 0 : (decimal)oT.HINHTHUCNHANDON;
                    MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
                    TOAANID = oT.TOAANID + "";
                }
                if (HinhThucNHanDon == 1)
                    lstHinhthucgui.Text = "Trực tiếp";
                else if (HinhThucNHanDon == 2)
                    lstHinhthucgui.Text = "Qua bưu điện";
                else if (HinhThucNHanDon == 3)
                {
                    lstHinhthucgui.Text = "Trực tuyến";
                    isTructuyen = true;
                    List<AKT_DON_DUONGSU> lstDSTT = dt.AKT_DON_DUONGSU.Where(x => x.DONID == ID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                    if (lstDSTT.Count > 0)
                        hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                }
                List<DONKK_USER_DKNHANVB> lstDKVB = dkk.DONKK_USER_DKNHANVB.Where(x => x.VUVIECID == ID && x.MALOAIVUVIEC == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI && x.TRANGTHAI == 1).ToList();
                if (lstDKVB.Count == 0)
                    lstDKNhanTD.Text = "Không có";
                else
                {
                    lstDKNhanTD.Text = "Có " + lstDKVB.Count.ToString() + " đương sự đăng ký nhận tống đạt trực tuyến";
                    isTructuyen = true;
                    foreach (DONKK_USER_DKNHANVB oDK in lstDKVB)
                    {
                        if (hddarrDuongsuTructuyen.Value == "")
                            hddarrDuongsuTructuyen.Value = oDK.DUONGSUID + "";
                        else
                            hddarrDuongsuTructuyen.Value += "," + oDK.DUONGSUID + "";
                    }
                }
                if (isTructuyen)
                {
                    hddIsTructuyen.Value = "1";
                    //trFile.Visible = true;
                }
                else
                {
                    trFile.Visible = false;
                    hddIsTructuyen.Value = "0";
                }
                if (MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && TOAANID == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    lbThongBaoThuHoi.Text = "";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    Cls_Comon.SetButton(btnXoa, false);
                    Cls_Comon.SetButton(btnSua, false);
                    Cls_Comon.SetButton(PHBS, false);
                    Cls_Comon.SetButton(VBDH, false);
                    Cls_Comon.SetButton(btnThuHoi, false);
                    return;
                }
                //check vụ án đã kết thúc không cho sửa xóa
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    Cls_Comon.SetButton(btnXoa, false);
                    Cls_Comon.SetButton(btnSua, false);
                    Cls_Comon.SetButton(PHBS, false);
                    Cls_Comon.SetButton(VBDH, false);
                    Cls_Comon.SetButton(btnThuHoi, false);
                    return;
                }
                cmdLammoi.Visible = false;
            }
        }

        private void LoadCombobox()
        {
            string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
            decimal ID = Convert.ToDecimal(current_id);

            //decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //AKT_DON_BL oBL = new AKT_DON_BL();
            //Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            //DataTable tbl = oBL.AKT_FILE_TONGDAT(ID);
            //AKT_SOTHAM_BANAN oND = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == VuAnId && x.TOAANID == TOAANID).FirstOrDefault();
            //DM_BIEUMAU bm52 = dt.DM_BIEUMAU.Where(bm => bm.ID == 230).FirstOrDefault();
            //AKT_FILE af = dt.AKT_FILE.Where(x => x.BIEUMAUID == 230 && x.DONID == VuAnId).FirstOrDefault();
            //AKT_TONGDAT td = dt.AKT_TONGDAT.Where(x => x.DONID == VuAnId && x.BIEUMAUID == 230).FirstOrDefault();
            //if (oND != null && td == null)
            //{
            //    DataRow dr = tbl.NewRow();
            //    dr["TENBM"] = bm52.MABM + ". " + bm52.TENBM;
            //    if (af == null)
            //    {
            //        dr["ID"] = -1;
            //    }
            //    else dr["ID"] = af.ID;
            //    tbl.Rows.Add(dr);
            //}
            //AKT_PHUCTHAM_BANAN oND2 = dt.AKT_PHUCTHAM_BANAN.Where(x => x.DONID == VuAnId && x.TOAANID == TOAANID).FirstOrDefault();
            //DM_BIEUMAU bm75 = dt.DM_BIEUMAU.Where(bm => bm.ID == 261).FirstOrDefault();
            //af = dt.AKT_FILE.Where(x => x.BIEUMAUID == 261 && x.DONID == VuAnId).FirstOrDefault();
            //td = dt.AKT_TONGDAT.Where(x => x.DONID == VuAnId && x.BIEUMAUID == 261).FirstOrDefault();
            //if (oND2 != null && td == null)
            //{
            //    DataRow dr = tbl.NewRow();
            //    dr["TENBM"] = bm75.MABM + ". " + bm75.TENBM;
            //    if (af == null)
            //    {
            //        dr["ID"] = -2;
            //    }
            //    else dr["ID"] = af.ID;
            //    tbl.Rows.Add(dr);
            //}

            AKT_DON objDon = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            decimal giai_doan = Convert.ToDecimal(objDon.MAGIAIDOAN);
            TONGDAT_BL oTongDatBL = new TONGDAT_BL();
            DataTable oDT = oTongDatBL.GET_BM_TONGDAT(ID, 4, giai_doan);
            foreach (DataRow row in oDT.Rows)
            {
                String sothongbao = "";
                if (row["SOTHONGBAO"] != null && row["SOTHONGBAO"].ToString() != ""
                    && row["NGAYTHONGBAO"] != null && row["NGAYTHONGBAO"].ToString() != "")
                {
                    sothongbao = " (Số thông báo: " + row["SOTHONGBAO"] + " - Ngày: " + GetTextDate(row["NGAYTHONGBAO"].ToString()) + ")";
                }
                row["TENBM"] = row["MABM"] + ". " + row["TENBM"] + sothongbao;
                //---------21/11/2025----  vnpt chỉnh lấy thêm cột so qd nagy qd
                string soQD = row["SOQUYETDINH"]?.ToString();
                string ngayQD = row["NGAYQD"]?.ToString();

                bool hasQD = !string.IsNullOrWhiteSpace(soQD);
                bool hasNgay = !string.IsNullOrWhiteSpace(ngayQD);

                if (hasQD || hasNgay)
                {
                    string tmp = " (";

                    if (hasQD)
                        tmp += "QĐ: " + soQD;

                    if (hasNgay)
                    {
                        if (hasQD)
                            tmp += " - ";

                        tmp += "Ngày: " + GetTextDate(ngayQD);
                    }

                    tmp += ")";

                    row["TENBM"] = row["TENBM"] + tmp;
                }

            }
            DataView dv = oDT.DefaultView;
            // VNPT -- Lê Bá Thọ -- 27/11/2025 sắp xếp theo ngày tạo 
            dv.Sort = "FILE_NGAYTAO ASC";
            oDT = dv.ToTable();

            oDT.DefaultView.Sort = "TENBM";
            ddlBieumau.DataSource = oDT;
            ddlBieumau.DataTextField = "TENBM";
            ddlBieumau.DataValueField = "ID_ANPHI_ID";
            ddlBieumau.SelectedValue = null;
            ddlBieumau.DataBind();
            ddlBieumau.Items.Insert(0, new ListItem("--- Chọn biểu mẫu ---", "0"));
        }

        private void ResetControls()
        {
            LoadCombobox();
            ddlBieumau.SelectedIndex = 0;
            txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
            txtVKS_Ngaygui.Visible = lblVKSNgaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
            rdbIsVKS.SelectedValue = "0";
            dgTructiep.DataSource = null;
            dgTructiep.DataBind();
            trDuongsu.Visible = false;
            //trVKS.Visible = false;
            trTructuyen.Visible = false;
            hddid.Value = "0";
            lstTenBM.Text = "";
            ddlBieumau.Visible = true;
            lbtDownload.Visible = false;
            cmdLammoi.Visible = false;
        }

        private bool CheckValid()
        {
            if (ddlBieumau.SelectedValue == "0" && ddlBieumau.Visible)
            {
                lbthongbao.Text = "Chưa chọn biểu mẫu cần tống đạt !";
                lbThongBaoThuHoi.Text = "";
                return false;
            }

            if (rdbIsVKS.SelectedIndex == 1)
            {
                if (txtVKS_Ngaygui.Text + "" == "")
                {
                    lbthongbao.Text = "Vui lòng nhập ngày gửi tống đạt tới viện kiểm sát!";
                    lbThongBaoThuHoi.Text = "";
                    txtVKS_Ngaygui.Focus();
                    return false;
                }
            }

            #region "Manhnd bo vi Thu ky khong tong dat chi xac dinh doi tuong se tong dat"
            //if (trTructuyen.Visible && hddFilePath.Value == "" && lbtDownload.Visible == false)
            //{
            //    lbthongbao.Text = "Chưa chọn tệp đính kèm để tống đạt trực tuyến !";
            //    return false;
            //}
            //if (trVKS.Visible)
            //{
            //    if (rdbIsVKS.SelectedValue == "1")
            //    {
            //        DateTime VKS_NgayGui, VKS_NgayNhan;
            //        bool isValidate = DateTime.TryParse(txtVKS_Ngaygui.Text, cul, DateTimeStyles.NoCurrentDateDefault, out VKS_NgayGui);
            //        if (txtVKS_Ngaygui.Text != "")
            //        {
            //            if (!isValidate)
            //            {
            //                lbthongbao.Text = "Ngày gửi đến Viện kiểm sát không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
            //                txtVKS_Ngaygui.Focus();
            //                return false;
            //            }
            //            else
            //            {
            //                if (DateTime.Compare(DateTime.Now, VKS_NgayGui) < 0)
            //                {
            //                    lbthongbao.Text = "Ngày gửi đến Viện kiểm sát không được lớn hơn ngày hiện tại.";
            //                    txtVKS_Ngaygui.Focus();
            //                    return false;
            //                }
            //            }
            //        }
            //        if (txtVKS_NgayNhan.Text != "")
            //        {
            //            isValidate = DateTime.TryParse(txtVKS_NgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out VKS_NgayNhan);
            //            if (!isValidate)
            //            {
            //                lbthongbao.Text = "Ngày Viện kiểm sát nhận không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
            //                txtVKS_NgayNhan.Focus();
            //                return false;
            //            }
            //            else
            //            {
            //                if (DateTime.Compare(DateTime.Now, VKS_NgayNhan) < 0)
            //                {
            //                    lbthongbao.Text = "Ngày Viện kiểm sát nhận không được lớn hơn ngày hiện tại.";
            //                    txtVKS_NgayNhan.Focus();
            //                    return false;
            //                }

            //                if (txtVKS_NgayNhan.Text != "" && DateTime.Compare(VKS_NgayNhan, VKS_NgayGui) < 0)
            //                {
            //                    lbthongbao.Text = "Ngày Viện kiểm sát nhận không được nhỏ hơn ngày gửi.";
            //                    txtVKS_NgayNhan.Focus();
            //                    return false;
            //                }
            //            }
            //        }
            //    }
            //}
            #endregion
            bool IsChonDuongSu = false;
            if (trDuongsu.Visible && dgTructiep.Items.Count > 0)
            {
                foreach (DataGridItem Item in dgTructiep.Items)
                {
                    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                    DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                    DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                    DropDownList ddlTCTT = (DropDownList)Item.FindControl("ddlTCTT");
                    TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                    Label lbTenDuongSu = (Label)Item.FindControl("lbTenDuongSu");
                    if (chkIsSend.Checked)
                    {
                        IsChonDuongSu = true;
                        if (string.IsNullOrEmpty(txtNgaygui.Text) && (ddlHinhthucgui.SelectedValue == "2" || ddlHinhthucgui.SelectedValue == "1"))
                        {
                            lbthongbao.Text = "Vui lòng nhập ngày gửi";
                            lbThongBaoThuHoi.Text = "";
                            return false;
                        }
                        //if (ddlHinhthucgui.SelectedValue == "1")
                        //{
                        //    if (ddlQuocGiaUT.SelectedValue == "0")
                        //    {
                        //        lbthongbao.Text = "Vui lòng nhập quốc gia";
                        //        lbThongBaoThuHoi.Text = "";
                        //        return false;
                        //    }
                        //    if (string.IsNullOrEmpty(txtCoquan.Text))
                        //    {
                        //        lbthongbao.Text = "Vui lòng nhập cơ quan";
                        //        lbThongBaoThuHoi.Text = "";
                        //        return false;
                        //    }
                        //}
                        //if (ddlTCTT.SelectedValue == "-1")
                        //{
                        //    lbthongbao.Text = "Vui lòng chọn tư cách tố tụng";
                        //    return false;
                        //}
                        #region "Manhnd bo do Van thu se thong dat"
                        //DateTime NgayGui, NgayNhan;
                        //bool isValidate = DateTime.TryParse(txtNgaygui.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayGui);
                        //if (txtNgaygui.Text != "")
                        //{
                        //    if (!isValidate)
                        //    {
                        //        lbthongbao.Text = "Ngày gửi đến đương sự không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                        //        txtNgaygui.Focus();
                        //        return false;
                        //    }
                        //    else
                        //    {
                        //        if (DateTime.Compare(DateTime.Now, NgayGui) < 0)
                        //        {
                        //            lbthongbao.Text = "Ngày gửi đến đương sự không được lớn hơn ngày hiện tại.";
                        //            txtNgaygui.Focus();
                        //            return false;
                        //        }
                        //    }
                        //}
                        //if (txtNgayNhan.Text != "")
                        //{
                        //    isValidate = DateTime.TryParse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhan);
                        //    if (!isValidate)
                        //    {
                        //        lbthongbao.Text = "Ngày nhận không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                        //        txtNgayNhan.Focus();
                        //        return false;
                        //    }
                        //    else
                        //    {
                        //        if (DateTime.Compare(DateTime.Now, NgayNhan) < 0)
                        //        {
                        //            lbthongbao.Text = "Ngày nhận không được lớn hơn ngày hiện tại.";
                        //            txtNgayNhan.Focus();
                        //            return false;
                        //        }

                        //        if (txtNgayNhan.Text != "" && DateTime.Compare(NgayNhan, NgayGui) < 0)
                        //        {
                        //            lbthongbao.Text = "Ngày nhận không được nhỏ hơn ngày gửi.";
                        //            txtNgayNhan.Focus();
                        //            return false;
                        //        }
                        //    }
                        //}
                        #endregion
                    }
                }
            }

            if (trDuongsu.Visible && dgTructuyen.Items.Count > 0)
            {
                foreach (DataGridItem Item in dgTructuyen.Items)
                {
                    CheckBox chkIsSendTT = (CheckBox)Item.FindControl("chkIsSendTT");
                    if (chkIsSendTT.Checked)
                    {
                        IsChonDuongSu = true;
                    }
                }
            }
            if (!IsChonDuongSu)
            {
                lbthongbao.Text = "Chưa chọn đương sự để tống đạt. Hãy chọn lại.";
                lbThongBaoThuHoi.Text = "";
                return false;
            }
            return true;
        }

        private List<AKT_TONGDAT_GS> convertToAKT_TONGDATFromDataTable(DataTable dataTable)
        {
            List<AKT_TONGDAT_GS> aKT_TONGDATs = new List<AKT_TONGDAT_GS>();
            foreach (DataRow row in dataTable.Rows)
            {
                AKT_TONGDAT_GS tONGDAT = new AKT_TONGDAT_GS();
                tONGDAT.ID = Convert.ToDecimal(row["ID"]);
                try
                {
                    tONGDAT.BIEUMAUID = Convert.ToDecimal(row["BIEUMAUID"]);
                }
                catch
                {
                    tONGDAT.BIEUMAUID = null;
                }
                try
                {
                    tONGDAT.DONID = Convert.ToDecimal(row["DONID"]);
                }
                catch
                {
                    tONGDAT.DONID = null;
                }
                try
                {
                    tONGDAT.FILEID = Convert.ToDecimal(row["FILEID"]);
                }
                catch
                {
                    tONGDAT.FILEID = null;
                }
                try
                {
                    tONGDAT.IS_TD_VKS = Convert.ToDecimal(row["IS_TD_VKS"]);
                }
                catch
                {
                    tONGDAT.IS_TD_VKS = null;
                }
                try
                {
                    tONGDAT.IS_TD_VKS_NGAY = Convert.ToDateTime(row["IS_TD_VKS_NGAY"]);
                }
                catch
                {
                    tONGDAT.IS_TD_VKS_NGAY = null;
                }

                tONGDAT.KIEUFILE = "" + row["KIEUFILE"];
                tONGDAT.LYDOTHUHOI = "" + row["LYDOTHUHOI"];
                try
                {
                    tONGDAT.NGAYDANG_CTTDT = Convert.ToDateTime(row["NGAYDANG_CTTDT"]);
                }
                catch
                {
                    tONGDAT.NGAYDANG_CTTDT = null;
                }
                try
                {
                    tONGDAT.NGAYNHANTONGDAT = Convert.ToDateTime(row["NGAYNHANTONGDAT"]);
                }
                catch
                {
                    tONGDAT.NGAYNHANTONGDAT = null;
                }
                try
                {
                    tONGDAT.NGAYSUA = Convert.ToDateTime(row["NGAYSUA"]);
                }
                catch
                {
                    tONGDAT.NGAYSUA = null;
                }
                try
                {
                    tONGDAT.NGAYTAO = Convert.ToDateTime(row["NGAYTAO"]);
                }
                catch
                {
                    tONGDAT.NGAYTAO = null;
                }
                try
                {
                    tONGDAT.NGAYTHUHOI = Convert.ToDateTime(row["NGAYTHUHOI"]);
                }
                catch
                {
                    tONGDAT.NGAYTHUHOI = null;
                }
                tONGDAT.NGUOISUA = "" + row["NGUOISUA"];
                tONGDAT.NGUOITAO = "" + row["NGUOITAO"];
                tONGDAT.NOIDUNGFILE = "" + row["NOIDUNGFILE"];
                tONGDAT.TENFILE = "" + row["TENFILE"];
                tONGDAT.TOAANID = Convert.ToDecimal(row["TOAANID"]);
                tONGDAT.TRANGTHAI = Convert.ToDecimal(row["TRANGTHAI"]);
                tONGDAT.URL_FILE = "" + row["URL_FILE"];
                try
                {
                    tONGDAT.MAPID = Convert.ToDecimal(row["MAPID"]);
                }
                catch
                {
                    tONGDAT.MAPID = null;
                }
                try
                {
                    tONGDAT.MAP_TABLE = row["MAP_TABLE"].ToString();
                }
                catch
                {
                    tONGDAT.MAP_TABLE = null;
                }
                try
                {
                    tONGDAT.TOA_GIAIQUYET_ID = Convert.ToDecimal(row["TOA_GIAIQUYET_ID"]);
                }
                catch
                {
                    tONGDAT.TOA_GIAIQUYET_ID = null;
                }
                aKT_TONGDATs.Add(tONGDAT);
            }
            return aKT_TONGDATs;
        }

        private List<AKT_TONGDAT_NGUOINHAN_GS> convertToAKT_TONGDATDOITUONGFromDataTable(DataTable dataTable)
        {
            List<AKT_TONGDAT_NGUOINHAN_GS> aKT_TONGDATs = new List<AKT_TONGDAT_NGUOINHAN_GS>();
            foreach (DataRow row in dataTable.Rows)
            {
                AKT_TONGDAT_NGUOINHAN_GS tONGDAT = new AKT_TONGDAT_NGUOINHAN_GS();
                tONGDAT.COQUAN = row["COQUAN"] + "";
                tONGDAT.DIACHI = row["DIACHI"] + "";
                tONGDAT.IS_SUA = row["IS_SUA"] + "";
                try
                {
                    tONGDAT.DUONGSUID = Convert.ToDecimal(row["DUONGSUID"]);
                }
                catch
                {
                    tONGDAT.DUONGSUID = null;
                }
                try
                {
                    tONGDAT.HINHTHUCGUI = Convert.ToDecimal(row["HINHTHUCGUI"]);
                }
                catch
                {
                    tONGDAT.HINHTHUCGUI = null;
                }
                tONGDAT.ID = Convert.ToDecimal(row["ID"]);
                try
                {
                    tONGDAT.IS_UTTP = Convert.ToDecimal(row["ISUTTP"]);
                }
                catch
                {
                    tONGDAT.IS_UTTP = null;
                }
                try
                {
                    tONGDAT.KETQUAUTTP = Convert.ToDecimal(row["KETQUAUTTP"]);
                }
                catch
                {
                    tONGDAT.KETQUAUTTP = null;
                }
                tONGDAT.MATUCACH = "" + row["MATUCACH"];
                try
                {
                    tONGDAT.NGAYGUI = Convert.ToDateTime(row["NGAYGUI"]);
                }
                catch
                {
                    tONGDAT.NGAYGUI = null;
                }
                try
                {
                    tONGDAT.NGAYNHANTONGDAT = Convert.ToDateTime(row["NGAYNHANTONGDAT"]);
                }
                catch
                {
                    tONGDAT.NGAYNHANTONGDAT = null;
                }
                try
                {
                    tONGDAT.NGAYPHATHANH = Convert.ToDateTime(row["NGAYPHATHANH"]);
                }
                catch
                {
                    tONGDAT.NGAYPHATHANH = null;
                }
                try
                {
                    tONGDAT.NGAYTAO = Convert.ToDateTime(row["NGAYTAO"]);
                }
                catch
                {
                    tONGDAT.NGAYTAO = null;
                }

                tONGDAT.NGUOITAO = "" + row["NGUOITAO"] == "" ? null : row["NGUOITAO"] + " ";
                tONGDAT.NOIDUNG = "" + row["NOIDUNG"] == "" ? null : row["NOIDUNG"] + " ";
                tONGDAT.NOINHAN = "" + row["NOINHAN"] == "" ? null : row["NOINHAN"] + " ";
                try
                {
                    tONGDAT.QUOCGIA = Convert.ToDecimal(row["QUOCGIA"]);
                }
                catch
                {
                    tONGDAT.QUOCGIA = null;
                }
                try
                {
                    tONGDAT.TONGDATID = Convert.ToDecimal(row["TONGDATID"]);
                }
                catch
                {
                    tONGDAT.TONGDATID = null;
                }
                try
                {
                    tONGDAT.TRANGTHAI = Convert.ToDecimal(row["TRANGTHAI"]);
                }
                catch
                {
                    tONGDAT.TRANGTHAI = null;
                }
                try
                {
                    tONGDAT.UTTP = Convert.ToDecimal(row["UTTP"]);
                }
                catch
                {
                    tONGDAT.UTTP = null;
                }
                try
                {
                    tONGDAT.MAPID = Convert.ToDecimal(row["MAPID"]);
                }
                catch
                {
                    tONGDAT.MAPID = null;
                }
                try
                {
                    tONGDAT.TOA_GIAIQUYET_ID = Convert.ToDecimal(row["TOA_GIAIQUYET_ID"]);
                }
                catch
                {
                    tONGDAT.TOA_GIAIQUYET_ID = null;
                }
                // VNPT VŨ VĂN QUÂN 13:00 03/11/2025
                // thêm trường thời gian xem, thời gian nhận trả về grid
                try
                {
                    tONGDAT.NGAYGUI_THANHCONG = Convert.ToDateTime(row["NGAYGUI_THANHCONG"]);
                }
                catch
                {
                    tONGDAT.NGAYGUI_THANHCONG = null;
                }
                try
                {
                    tONGDAT.NGAYXEM = Convert.ToDateTime(row["NGAYXEM"]);
                }
                catch
                {
                    tONGDAT.NGAYXEM = null;
                }
                //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEID
                try
                {
                    tONGDAT.XACTHUC_DLDCQG = Convert.ToDecimal(row["XACTHUC_DLDCQG"]);
                }
                catch
                {
                    tONGDAT.XACTHUC_DLDCQG = null;
                }
                aKT_TONGDATs.Add(tONGDAT);
            }
            return aKT_TONGDATs;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            BL.GSTP.AKT.AKT_TONGDAT_BL Bl = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            //lbthongbao.Text = "";
            string CONTENT_JSON_OLD = "";
            string CONTENT_JSON = "";
            if (CheckValid() == true)
            {
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id), TongDatID = hddid.Value + "" == "" ? 0 : Convert.ToDecimal(hddid.Value);
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AKT_FILE oF = new AKT_FILE();
                string status; // 
                List<decimal> lst = new List<decimal>();
                string temp = ddlBieumau.SelectedValue.Split('_')[0];
                if (String.IsNullOrEmpty(temp))
                    temp = "0";
                decimal bieuMauID = Convert.ToDecimal(temp);
                string temp2 = ddlBieumau.SelectedValue.Split('_')[1];
                if (String.IsNullOrEmpty(temp2))
                    temp2 = "0";
                decimal ANPHI_ID_DROPDOWN = Convert.ToDecimal(temp2);
                string mapTable = "";

                ListItem itemBieuMau = ddlBieumau.Items.FindByValue(ddlBieumau.SelectedValue);

                DM_BIEUMAU dM_BIEUMAU = dt.DM_BIEUMAU.Where(x => x.ID == bieuMauID).FirstOrDefault();

                AKT_TONGDAT adTongDat = null;

                if (ANPHI_ID_DROPDOWN != 0)
                {
                    adTongDat = dt.AKT_TONGDAT.Where(x => x.DONID == DONID && x.BIEUMAUID == bieuMauID && x.MAPID == ANPHI_ID_DROPDOWN).FirstOrDefault();
                }
                else
                {
                    adTongDat = dt.AKT_TONGDAT.Where(x => x.DONID == DONID && x.BIEUMAUID == bieuMauID).FirstOrDefault();
                }

                AKT_TONGDAT_GS oND = null;
                if (TongDatID != 0)
                {
                    oND = convertToAKT_TONGDATFromDataTable(Bl.AKT_TONGDAT_GETBYID(TongDatID)).FirstOrDefault();
                }

                bool isNew = false;

                bool isUpdate = false;
                AKT_TONGDAT td = new AKT_TONGDAT();
                List<AKT_TONGDAT_DOITUONG> td_dt = new List<AKT_TONGDAT_DOITUONG>();
                // 5/12/2025 vnpt -check trùng ddlnoinhan
                if (trDuongsu.Visible)
                {
                    List<string> DuongsuIDs = new List<string>();
                    bool ischeckChonKhac = false;
                    foreach (DataGridItem Item in dgTructiep.Items)
                    {
                        DropDownList ddlTCTT = (DropDownList)Item.FindControl("ddlTCTT");
                        CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                        DropDownList ddlNoiNhan = (DropDownList)Item.FindControl("ddlNoiNhan");
                        decimal? DuongsuID;
                        try
                        {
                            DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                        }
                        catch
                        {
                            DuongsuID = null;
                        }
                        if (ddlNoiNhan.Visible == true)
                        {
                            if (DuongsuID != null)
                            {
                                DuongsuIDs.Add(DuongsuID.ToString());
                            }
                            if (ddlNoiNhan.SelectedValue == "KHÁC" || string.IsNullOrEmpty(ddlNoiNhan.SelectedValue) || ddlNoiNhan.SelectedValue == "-1")
                            {
                                ischeckChonKhac = true;
                                break;
                            }
                        }
                    }
                    if (ischeckChonKhac)
                    {
                        lbthongbao.Text = "Có đối tượng tống đạt chưa chọn nơi nhận!";
                        return;
                    }
                    var duplicates = DuongsuIDs.GroupBy(x => x).Where(g => g.Count() > 1).Select(g => g.Key).ToList();
                    if (duplicates.Any())
                    {
                        lbthongbao.Text = "Có đối tượng tống đạt trùng!";
                        return;
                    }
                }
                if (oND == null)
                {
                    isNew = true;
                    oND = new AKT_TONGDAT_GS();
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TRANGTHAI = 0;
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    isUpdate = true;
                    
                    td = dt.AKT_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
                    td_dt = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == td.ID && x.TRANGTHAI == 1).ToList();

                    CONTENT_JSON_OLD = JsonConvert.SerializeObject(td, Formatting.Indented);
                }
                if (dM_BIEUMAU.MABM == "100-DS")
                {
                    oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_ANPHI;
                    oND.MAPID = ANPHI_ID_DROPDOWN;
                }
                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (isNew)
                {
                    decimal bieu_mau_id = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                    //---------27/11/2025---- Lê Bá Thọ vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                    if (ddlBieumau.SelectedValue.Split('_').Length > 2)
                    {
                        decimal FILEID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[2]);
                        oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id && x.ID == FILEID).FirstOrDefault();
                    }
                    else
                    {
                        oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id).FirstOrDefault();
                    }
                    //---------01/12/2025----  vnpt chỉnh lấy thêm mapid maptable
                    if (oF != null)
                    {
                        oND.FILEID = oF.ID;
                        var donxuly = dt.AKT_DON_XULY.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (donxuly != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_DON_XULY;
                            oND.MAPID = donxuly.ID;
                        }
                        var donxulydct =
                                        (from dx in dt.AKT_DON_XULY
                                         join dct in dt.DON_CHITIET
                                             on dx.DON_CHITIETID equals dct.ID
                                         where dx.FILEID == oF.ID
                                               && dct.DONID == DONID
                                         select dx).FirstOrDefault();

                        if (donxulydct != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_DON_XULY;
                            oND.MAPID = donxulydct.ID;
                        }

                        var anphi = dt.AKT_ANPHI.FirstOrDefault(x => x.DONID == DONID );

                        if (anphi != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_ANPHI;
                            oND.MAPID = anphi.ID;
                        }

                        var sothamthuly = dt.AKT_SOTHAM_THULY.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (sothamthuly != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_SOTHAM_THULY;
                            oND.MAPID = sothamthuly.ID;
                        }

                        var sothamquyetdinh = dt.AKT_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (sothamquyetdinh != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_SOTHAM_QUYETDINH;
                            oND.MAPID = sothamquyetdinh.ID;
                        }

                        var phucthamthuly = dt.AKT_PHUCTHAM_THULY.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (phucthamthuly != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_PHUCTHAM_THULY;
                            oND.MAPID = phucthamthuly.ID;
                        }

                        var phucthamquyetdinh = dt.AKT_PHUCTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (phucthamquyetdinh != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_PHUCTHAM_QUYETDINH;
                            oND.MAPID = phucthamquyetdinh.ID;
                        }
                        var banansotham = dt.AKT_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (banansotham != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_SOTHAM_BANAN;
                            oND.MAPID = banansotham.ID;
                        }

                        var bananphuctham = dt.AKT_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == DONID && x.FILEID == oF.ID);

                        if (bananphuctham != null)
                        {
                            oND.MAP_TABLE = ENUM_MAP_TABLE.AKT_PHUCTHAM_BANAN;
                            oND.MAPID = bananphuctham.ID;
                        }
                    }
                    oND.BIEUMAUID = bieu_mau_id;

                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.ID = Bl.AKT_TONGDAT_UPIN(oND);

                    TongDatID = oND.ID;//14/01/2025

                    //AnhPN log
                    CONTENT_JSON = JsonConvert.SerializeObject(oND, Formatting.Indented);
                    LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                    log.InsertLog("AKT_TONGDAT", oND.ID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Insert", "", CONTENT_JSON, "");
                }
                else
                {
                    oF = dt.AKT_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                }
                dt.SaveChanges();

                oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);

                if (!isNew)
                {
                    //AnhPN log
                    CONTENT_JSON = JsonConvert.SerializeObject(oND, Formatting.Indented);
                    LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                    log.InsertLog("AKT_TONGDAT", oND.ID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", lbthongbao.Text, CONTENT_JSON, CONTENT_JSON_OLD);
                }
                if (trDuongsu.Visible)
                {
                    decimal TongdatID = oND.ID;
                    List<decimal> IDs = new List<decimal>();
                    foreach (DataRow row in TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYTONGDATID(TongDatID).Rows)
                    {
                        IDs.Add(Convert.ToDecimal(row["ID"]));
                    }
                    foreach (DataGridItem Item in dgTructiep.Items)
                    {
                        CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                        TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                        TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                        DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                        DropDownList ddlTCTT = (DropDownList)Item.FindControl("ddlTCTT");
                        DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                        DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                        TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                        TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                        DropDownList ddlNoiNhan = (DropDownList)Item.FindControl("ddlNoiNhan");
                        TextBox txtDiachi = (TextBox)Item.FindControl("txtDiachi");
                        TextBox txtNgayphathanh = (TextBox)Item.FindControl("txtNgayphathanh");
                        decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);
                        decimal? DuongsuID;
                        decimal? ANPHI_ID;
                        string SOTHONGBAO = "";
                        string MATHONGBAO = "";
                        try
                        {
                            DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                        }
                        catch
                        {
                            DuongsuID = null;
                        }
                        try
                        {
                            ANPHI_ID = Convert.ToDecimal(Item.Cells[25].Text);
                            SOTHONGBAO = Item.Cells[26].Text;
                            MATHONGBAO = Item.Cells[27].Text;
                        }
                        catch
                        {
                            ANPHI_ID = null;
                            SOTHONGBAO = "";
                            MATHONGBAO = "";
                        }
                        decimal? ID;
                        List<AKT_TONGDAT_NGUOINHAN_GS> lstCheck;
                        try
                        {
                            if (Item.Cells[7].Text == "&nbsp;")
                            {
                                ID = null;
                                lstCheck = new List<AKT_TONGDAT_NGUOINHAN_GS>();
                            }
                            else
                            {
                                ID = Convert.ToDecimal(Item.Cells[7].Text);
                                lstCheck = convertToAKT_TONGDATDOITUONGFromDataTable(Bl.AKT_TONGDATDOITUONG_GETBYID(ID.Value));
                            }
                        }
                        catch
                        {
                            ID = null;
                            lstCheck = new List<AKT_TONGDAT_NGUOINHAN_GS>();
                        }

                        AKT_TONGDAT_NGUOINHAN_GS oTD = null;
                        if (lstCheck.Count > 0)
                        {
                            oTD = lstCheck[0];
                            CONTENT_JSON_OLD = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                        }
                        else
                        {
                            oTD = new AKT_TONGDAT_NGUOINHAN_GS();
                        }

                        oTD.DIACHI = txtDiachi.Text + "" == "" ? null : txtDiachi.Text;
                        oTD.TONGDATID = TongdatID;
                        oTD.DUONGSUID = DuongsuID;
                        if (ddlTCTT.Visible == true)
                        {
                            oTD.MATUCACH = ddlTCTT.SelectedValue;
                        }
                        else
                        {
                            oTD.MATUCACH = Item.Cells[1].Text;
                        }
                        oTD.HINHTHUCGUI = vHinhthucgui;
                        try
                        {
                            if (ddlNoiNhan.SelectedValue == "KHÁC")
                            {
                                var txtNoiNhan = Item.FindControl("txtNoiNhan") as TextBox;
                                oTD.NOINHAN = txtNoiNhan.Text;
                            }
                            else
                            {
                                oTD.NOINHAN = ddlNoiNhan.SelectedItem.Text;
                            }
                        }
                        catch
                        {
                            oTD.NOINHAN = null;
                        }

                        DateTime ngayGui;
                        bool isCheck = DateTime.TryParse(txtNgaygui.Text, cul, DateTimeStyles.None, out ngayGui);
                        if (isCheck)
                        {
                            oTD.NGAYGUI = ngayGui;
                        }
                        else
                        {
                            oTD.NGAYGUI = null;
                        }

                        try
                        {
                            oTD.NGAYPHATHANH = Convert.ToDateTime(txtNgayphathanh.Text);
                        }
                        catch
                        {
                            oTD.NGAYPHATHANH = null;
                        }
                        try
                        {
                            oTD.NGAYNHANTONGDAT = Convert.ToDateTime(txtNgayNhan.Text);
                        }
                        catch
                        {
                            oTD.NGAYNHANTONGDAT = null;
                        }
                        if (chkIsSend.Checked)
                        {
                            if (vHinhthucgui == 2 || vHinhthucgui == 1)
                            {
                                if (oTD.TRANGTHAI == null || oTD.TRANGTHAI == 0 || oTD.TRANGTHAI == 2)
                                {
                                    oTD.TRANGTHAI = 1;
                                }

                                oTD.QUOCGIA = Convert.ToDecimal(ddlQuocGiaUT.SelectedValue);
                                oTD.COQUAN = txtCoquan.Text;
                                oTD.NOIDUNG = txtNoidung.Text;
                                oTD.KETQUAUTTP = Convert.ToDecimal(ddlketquauttp.SelectedValue);
                            }
                            else if (vHinhthucgui == 0)
                            {
                                //oTD.TRANGTHAI = 6;
                                oTD.TRANGTHAI = 1;
                                oTD.QUOCGIA = 0;
                                oTD.COQUAN = "";
                                oTD.NOIDUNG = "";
                                oTD.KETQUAUTTP = 0;
                            }
                            else if (vHinhthucgui == 5)
                            {
                                // oTD.TRANGTHAI = 7;
                                oTD.TRANGTHAI = 1;
                                oTD.QUOCGIA = 0;
                                oTD.COQUAN = "";
                                oTD.NOIDUNG = "";
                                oTD.KETQUAUTTP = 0;
                            }
                            oTD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            Bl.AKT_TONGDATDOITUONG_UPIN(oTD);
                            dt.SaveChanges();

                            if (lstCheck.Count > 0)
                            {
                                //AnhPN log
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                                log.InsertLog("AKT_TONGDAT_DOITUONG", TongDatID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", lbthongbao.Text, CONTENT_JSON, CONTENT_JSON_OLD);
                            }
                            else
                            {
                                //AnhPN log
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                                log.InsertLog("AKT_TONGDAT_DOITUONG", oTD.TONGDATID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Insert", lbthongbao.Text, CONTENT_JSON, "");
                            }

                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            if (DuongsuID != null)
                            {
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, (decimal)DuongsuID, "4");
                                //Log DVCQG_THANH_TOAN
                                LOG_TONGDAT_QLTA logDVCQG = new LOG_TONGDAT_QLTA();
                                logDVCQG.InsertLog("DVCQG_THANH_TOAN", oTD.TONGDATID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", "Cập nhật thông tin tống đạt sang dịch vụ công", CONTENT_JSON, "");
                            }
                        }
                        else
                        {
                            oTD.TRANGTHAI = 0;

                            if (lstCheck.Count > 0)
                            {
                                foreach (var item in lstCheck)
                                {
                                    dt.SaveChanges();
                                }
                            }
                            oTD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            Bl.AKT_TONGDATDOITUONG_UPIN(oTD);

                            if (lstCheck.Count > 0)
                            {
                                //AnhPN log
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                                log.InsertLog("AKT_TONGDAT_DOITUONG", TongDatID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", lbthongbao.Text, CONTENT_JSON, CONTENT_JSON_OLD);
                            }
                            else
                            {
                                //AnhPN log
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                                log.InsertLog("AKT_TONGDAT_DOITUONG", oTD.TONGDATID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Insert", lbthongbao.Text, CONTENT_JSON, "");
                            }
                        }
                        if (IDs.Count > 0)
                        {
                            if (oTD.ID != null)
                                IDs.Remove(oTD.ID.Value);
                        }
                    }
                    if (IDs.Count > 0)
                    {
                        foreach (decimal i in IDs)
                            TONGDAT_BL.AKT_TONGDATDOITUONG_REMOVEBYID(i);
                    }
                }
                if (trTructuyen.Visible)
                {
                    decimal TongdatID = oND.ID;
                    foreach (DataGridItem Item in dgTructuyen.Items)
                    {
                        CheckBox chkIsSendTT = (CheckBox)Item.FindControl("chkIsSendTT");
                        decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                        List<AKT_TONGDAT_DOITUONG> lstCheck = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).ToList();
                        AKT_TONGDAT_DOITUONG oTD = null;
                        if (lstCheck.Count > 0)
                        {
                            oTD = lstCheck[0];
                        }
                        else
                        {
                            oTD = new AKT_TONGDAT_DOITUONG();
                        }
                        oTD.TONGDATID = TongdatID;
                        oTD.DUONGSUID = DuongsuID;
                        oTD.MATUCACH = Item.Cells[1].Text;
                        oTD.HINHTHUCGUI = 1;

                        if (chkIsSendTT.Checked)
                        {
                            if (oTD.TRANGTHAI == null || oTD.TRANGTHAI == 0 || oTD.TRANGTHAI == 2)
                            {
                                oTD.TRANGTHAI = 1;
                            }

                            if (lstCheck.Count == 0)
                            {
                                oTD.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AKT_TONGDAT_DOITUONG.Add(oTD);
                            }    
                                
                            dt.SaveChanges();

                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            if (DuongsuID != null)
                            {
                                CONTENT_JSON = JsonConvert.SerializeObject(oTD, Formatting.Indented);
                                obj.DVCQG_THANH_TOAN_UP_TONGDAT(oND.ID, (decimal)DuongsuID, "4");
                                //Log DVCQG_THANH_TOAN
                                LOG_TONGDAT_QLTA logDVCQG = new LOG_TONGDAT_QLTA();
                                logDVCQG.InsertLog("DVCQG_THANH_TOAN", oTD.TONGDATID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Update", "Cập nhật thông tin tống đạt sang dịch vụ công", CONTENT_JSON, "");
                            }
                        }
                    }
                }

                try
                {
                    lst.Add(oND.ID);
                    status = CallApi(lst);
                    if (status == "SUCCESS")
                    {
                        lbthongbao.Text = "Lưu và gửi thành công !";
                    }
                    else
                    {
                        lbthongbao.Text = "Lưu và gửi thất bại !";

                        if (isUpdate) // Sửa
                        {
                            ReUpdateStatusUpdate(td_dt, TongDatID);
                        }
                        else // Thêm mới
                        {
                            decimal BieuMauID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                            decimal MAPID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[1]);
                            ReUpdateStatusAdd(DONID, ToaAnID, BieuMauID, MAPID);
                        }
                    }
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Gửi sang VBĐH thất bại do không thể gọi api !";
                    if (ex.InnerException != null)
                    {
                        var deepMessage = ex.InnerException?.InnerException?.Message ?? ex.InnerException?.Message ?? ex.Message;
                        Console.WriteLine("Chi tiết lỗi sâu nhất: " + deepMessage);
                        lbthongbao.Text = "Gửi sang VBĐH thất bại do không thể gọi api ! " + deepMessage;
                    }
                    else
                    {
                        Console.WriteLine("Chi tiết lỗi: " + ex.Message);
                        lbthongbao.Text = "Gửi sang VBĐH thất bại do không thể gọi api ! " + ex.Message;
                    }

                    if (isUpdate) // Sửa
                    {
                        ReUpdateStatusUpdate(td_dt, TongDatID);
                    }
                    else // Thêm mới
                    {
                        decimal BieuMauID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                        decimal MAPID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[1]);
                        ReUpdateStatusAdd(DONID, ToaAnID, BieuMauID, MAPID);
                    }
                }

                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbThongBaoThuHoi.Text = "";
            }
        }

        private void ReUpdateStatusAdd(decimal DonID, decimal ToaAnID, decimal BieuMauID, decimal MAPID)
        {
            AKT_TONGDAT td = dt.AKT_TONGDAT.Where(x => x.DONID == DonID && x.TOAANID == ToaAnID && x.BIEUMAUID == BieuMauID && (MAPID == 0 || x.MAPID == MAPID)).FirstOrDefault();
            List<AKT_TONGDAT_DOITUONG> td_dt = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == td.ID).ToList();
            foreach (var item in td_dt)
            {
                AKT_TONGDAT_NGUOINHAN_GS oTD = new AKT_TONGDAT_NGUOINHAN_GS();
                oTD.TONGDATID = item.TONGDATID;
                oTD.MATUCACH = item.MATUCACH;
                oTD.NGAYGUI = item.NGAYGUI;
                oTD.ID = item.ID;
                oTD.TRANGTHAI = 0;
                oTD.HINHTHUCGUI = item.HINHTHUCGUI;
                oTD.DUONGSUID = item.DUONGSUID;
                oTD.NGAYNHANTONGDAT = item.NGAYNHANTONGDAT;
                oTD.QUOCGIA = item.QUOCGIA;
                oTD.COQUAN = item.COQUAN;
                oTD.NOIDUNG = item.NOIDUNG;
                oTD.KETQUAUTTP = item.KETQUAUTTP;
                oTD.NGAYPHATHANH = item.NGAYPHATHANH;
                oTD.NGAYTAO = item.NGAYTAO;
                oTD.NGUOITAO = item.NGUOITAO;
                oTD.IS_UTTP = item.IS_UTTP;
                oTD.UTTP = item.UTTP;
                oTD.NOINHAN = item.NOINHAN;
                oTD.DIACHI = item.DIACHI;

                BL.GSTP.AKT.AKT_TONGDAT_BL Bl = new BL.GSTP.AKT.AKT_TONGDAT_BL();
                Bl.AKT_TONGDATDOITUONG_UPIN(oTD);
                dt.SaveChanges();
            }
        }

        private void ReUpdateStatusUpdate(List<AKT_TONGDAT_DOITUONG> td_dt, decimal TongDatId)
        {
            List<decimal> lstID = new List<decimal>();
            foreach (var itemtd in td_dt)
            {
                lstID.Add(itemtd.ID);
            }

            List<AKT_TONGDAT_DOITUONG> list_detail = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongDatId).ToList();
            foreach (var item in list_detail)
            {
                if (!lstID.Contains(item.ID))
                {
                    AKT_TONGDAT_NGUOINHAN_GS oTD = new AKT_TONGDAT_NGUOINHAN_GS();
                    oTD.TONGDATID = item.TONGDATID;
                    oTD.MATUCACH = item.MATUCACH;
                    oTD.NGAYGUI = item.NGAYGUI;
                    oTD.ID = item.ID;
                    oTD.TRANGTHAI = 0;
                    oTD.HINHTHUCGUI = item.HINHTHUCGUI;
                    oTD.DUONGSUID = item.DUONGSUID;
                    oTD.NGAYNHANTONGDAT = item.NGAYNHANTONGDAT;
                    oTD.QUOCGIA = item.QUOCGIA;
                    oTD.COQUAN = item.COQUAN;
                    oTD.NOIDUNG = item.NOIDUNG;
                    oTD.KETQUAUTTP = item.KETQUAUTTP;
                    oTD.NGAYPHATHANH = item.NGAYPHATHANH;
                    oTD.NGAYTAO = item.NGAYTAO;
                    oTD.NGUOITAO = item.NGUOITAO;
                    oTD.IS_UTTP = item.IS_UTTP;
                    oTD.UTTP = item.UTTP;
                    oTD.NOINHAN = item.NOINHAN;
                    oTD.DIACHI = item.DIACHI;

                    BL.GSTP.AKT.AKT_TONGDAT_BL Bl = new BL.GSTP.AKT.AKT_TONGDAT_BL();
                    Bl.AKT_TONGDATDOITUONG_UPIN(oTD);
                    dt.SaveChanges();
                }
            }
        }

        public void LoadGrid()
        {
            AKT_DON_BL oBL = new AKT_DON_BL();
            BL.GSTP.AKT.AKT_TONGDAT_BL TongDatBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
            decimal ID = Convert.ToDecimal(current_id), ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DataTable oDT = oBL.AKT_TONGDAT_GETLIST(ID, ToaAnID);
            var lstTongDat = convertToAKT_TONGDATFromDataTable(oDT);
            List<AKT_TONGDAT_NGUOINHAN_GS> lstNguoiNhan = new List<AKT_TONGDAT_NGUOINHAN_GS>();
            //  -- VNPT 06122025
            List<AKT_TONGDAT_GS> lstHaventDoituongtongdat = new List<AKT_TONGDAT_GS>();
            foreach (var tongdat in lstTongDat)
            {
                DataTable doiTuongDataTable = TongDatBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(tongdat.ID);
                if (doiTuongDataTable.Rows.Count == 0)
                {
                    lstHaventDoituongtongdat.Add(tongdat);
                }
                lstNguoiNhan.AddRange(convertToAKT_TONGDATDOITUONGFromDataTable(doiTuongDataTable));
            }
            if (oDT != null && lstNguoiNhan.Count == 0)
            {
                if (lstNguoiNhan.Count == 0)
                {
                    TONGDAT_BL obj = new TONGDAT_BL();
                    obj.TONGDAT_DELETE_ERROR(ID.ToString(), "4");
                }
            }
            // Remove các phần tử không có đối tượng -- VNPT 06122025
            lstTongDat.RemoveAll(x => lstHaventDoituongtongdat.Any(y => y.ID == x.ID));
            var pagesize = 0;
            if (pagesize == 0)
            {
                if (lstNguoiNhan.Count == 0)
                {
                    pagesize = 20;
                }
                else
                {
                    pagesize = lstNguoiNhan.Count;
                }
            }
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(pagesize), Convert.ToInt32(pagesize)).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + lstTongDat.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            dgList.DataSource = lstNguoiNhan;
            //---------21/11/2025----  vnpt chỉnh lấy page size
            if (lstNguoiNhan.Count > dgList.PageSize)
            {
                dgList.PageSize = pagesize;
            }
            dgList.DataBind();
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
            lbthongbao.Text = "";
            lbThongBaoThuHoi.Text = "";
        }

        public void xoa(decimal id)
        {
            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
            decimal _VALUE = 0;

            List<AKT_TONGDAT_DOITUONG> lst = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == id && (x.TRANGTHAI == 0 || x.TRANGTHAI == 2 || ((x.TRANGTHAI == 5 || x.TRANGTHAI == 6) && x.NGAYPHATHANH == null))).ToList();
            if (lst.Count > 0)
            {
                dt.AKT_TONGDAT_DOITUONG.RemoveRange(lst);
                dt.SaveChanges();
            }
            //--
            List<AKT_TONGDAT_DOITUONG> lst_obj = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == id).ToList();
            AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                if (lst_obj.Count == 0)
                {
                    obj.DVCQG_TT_REMOVE_TONGDAT(id, "4", ref _VALUE);
                    if (_VALUE == 1)
                    {
                        dt.AKT_TONGDAT.Remove(oND);
                        dt.SaveChanges();
                    }
                    else
                    {
                        lbThongBaoThuHoi.Text = "Đã phát sinh giao dịch thanh toán, bạn không được Xóa!";
                    }
                }
            }
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbThongBaoThuHoi.Text = "Xóa thành công!";
            lbthongbao.Text = "";
        }
        private DataTable Sort(DataTable table)
        {
            try
            {
                table.Columns.Add("isAdd");
            }
            catch
            {

            }
            foreach (DataRow row in table.Rows)
            {
                if (row["DUONGSUID"] + "" == "")
                {
                    row["isAdd"] = 1;
                }
                else
                {
                    row["isAdd"] = 0;
                }
            }
            DataView view = table.DefaultView;
            view.Sort = "isAdd";
            table = view.ToTable();
            return table;
        }

        private bool RowComparer(DataRow left, DataRow right) // left > right return true 
        {
            decimal left_isAdd = Convert.ToDecimal(left["isAdd"]);
            decimal right_isAdd = Convert.ToDecimal(right["isAdd"]);
            if (left_isAdd > right_isAdd)
            {
                return true;
            }
            string leftName = left["TENDUONGSU"] + "";
            string rightName = right["TENDUONGSU"] + "";

            if (string.Compare(leftName, rightName) > 0)
                return true;
            return false;
        }

        public void loadSua(decimal ID)
        {
            cmdLammoi.Visible = true;
            bool IsShowVKS = false;
            trThemFile.Visible = false;
            decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
            DateTime? IS_TD_VKS_NGAY = null;
            AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
            decimal? MapID = 0;
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                MapID = oND.MAPID;
            }
            ddlBieumau.Visible = false;
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
            if (oBM != null)
            {
                string sothongbao = "";
                DateTime? ngaythongbao = null;
                string BM_THONGBAO = "";
                if (MapID != null && MapID != 0)
                {
                    AKT_ANPHI aDS_ANPHI = dt.AKT_ANPHI.Where(x => x.ID == MapID).FirstOrDefault();
                    DON_MIENANPHI_BL dON_MIENANPHI = new DON_MIENANPHI_BL();

                    if (aDS_ANPHI != null)
                    {
                        DataTable DON_MIENANPHI = dON_MIENANPHI.GET_DON_MIENANPHI_BY_ANPHI_ID(aDS_ANPHI.ID, 4);
                        sothongbao = DON_MIENANPHI.Rows.Count > 0 ? DON_MIENANPHI.Rows[0]["SOTHONGBAO"].ToString() + DON_MIENANPHI.Rows[0]["STB_PHU"] : aDS_ANPHI.SOTHONGBAO + aDS_ANPHI.STB_PHU;
                        ngaythongbao = DON_MIENANPHI.Rows.Count > 0 ? Convert.ToDateTime(DON_MIENANPHI.Rows[0]["NGAYTHONGBAO"]) : aDS_ANPHI.NGAYTHONGBAO;
                    }

                    BM_THONGBAO = sothongbao != "" ? " (Số thông báo: " + sothongbao + " - Ngày: " + GetTextDate(ngaythongbao) + ")" : "";
                }

                lstTenBM.Text = oBM.TENBM + BM_THONGBAO;

                ddlBieumau.Items.Clear();
                ddlBieumau.Items.Add(new ListItem(oBM.MABM + " " + oBM.TENBM + BM_THONGBAO, oBM.ID.ToString() + "_" + MapID));
                ddlBieumau.SelectedIndex = 0;
            }
            if (IS_TD_VKS == 1)
            {
                //IsShowVKS = true;
                rdbIsVKS.SelectedValue = "1";
                lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
                txtVKS_Ngaygui.Enabled = txtVKS_NgayNhan.Enabled = false;

                txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? null : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);

                if (txtVKS_Ngaygui.Text != null && txtVKS_Ngaygui.Text != "")
                    rdbIsVKS.Enabled = false;
                else
                    rdbIsVKS.Enabled = true;
            }
            else
            {
                rdbIsVKS.SelectedValue = "0";
                txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
            }
            cmdLammoi.Visible = true;
            BL.GSTP.AKT.AKT_TONGDAT_BL TONGDATBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            DataTable nguoiNhans = new DataTable();
            if (oBM.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí  
            {
                nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(ID);
            }
            else
            {
                nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(ID);
            }
            nguoiNhans.Columns.Add("TUCACHTOTUNG_MA");
            nguoiNhans.Columns.Add("TONGDAT_DOITUONG");
            nguoiNhans.Columns.Add("TENDUONGSU");
            nguoiNhans.Columns.Add("TENTCTT");
            foreach (DataRow row in nguoiNhans.Rows)
            {
                string name = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(row["ID"]));
                row["TONGDAT_DOITUONG"] = row["ID"];
                row["ID"] = row["DUONGSUID"];
                row["TUCACHTOTUNG_MA"] = row["MATUCACH"];
                row["TENDUONGSU"] = name;
                row["TENTCTT"] = row["MATUCACH"];
            }
            nguoiNhans = Sort(nguoiNhans);
            //Set ngày gửi là ngày hiện tại
            if (nguoiNhans != null)
            {
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                    {
                        row["NGAYGUI"] = DateTime.Now;
                    }
                    Sothongbao.Value = row["SOTHONGBAO"].ToString(); // vnpt 03/12/2025
                }
            }
            dgTructiep.DataSource = nguoiNhans;
            dgTructiep.DataBind();
            loadBangSua(nguoiNhans.Rows.Count);
            trDuongsu.Visible = true;
            dgTructiep.Visible = true;
            if (FILEID > 0)
            {
                lbtDownload.Visible = true;
                hddFile.Value = FILEID + "";
            }
            else
                lbtDownload.Visible = false;
        }

        public void loadPhatHanhLai(decimal ID, decimal vID)
        {
            cmdLammoi.Visible = true;
            bool IsShowVKS = false;
            trThemFile.Visible = false;
            decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
            DateTime? IS_TD_VKS_NGAY = null;
            AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
            }
            ddlBieumau.Visible = false;
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
            if (oBM != null)
            {
                lstTenBM.Text = oBM.TENBM;
                ddlBieumau.Items.Clear();
                ddlBieumau.Items.Add(new ListItem(oBM.MABM + " " + oBM.TENBM, oBM.ID.ToString()));
                ddlBieumau.SelectedIndex = 0;
            }
            if (IS_TD_VKS == 1)
            {
                //IsShowVKS = true;
                rdbIsVKS.SelectedValue = "1";
                lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
                txtVKS_Ngaygui.Enabled = txtVKS_NgayNhan.Enabled = false;

                txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? null : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);

                if (txtVKS_Ngaygui.Text != null && txtVKS_Ngaygui.Text != "")
                    rdbIsVKS.Enabled = false;
                else
                    rdbIsVKS.Enabled = true;
            }
            else
            {
                rdbIsVKS.SelectedValue = "0";
                txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
            }
            cmdLammoi.Visible = true;
            BL.GSTP.AKT.AKT_TONGDAT_BL TONGDATBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            DataTable nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(ID);
            DataTable nguoiNhan = TONGDATBL.AKT_TONGDATDOITUONG_GETBYID(vID);
            int dataCount = nguoiNhans.Rows.Count;
            nguoiNhans.Columns.Add("TUCACHTOTUNG_MA");
            nguoiNhans.Columns.Add("TONGDAT_DOITUONG");
            nguoiNhans.Columns.Add("TENDUONGSU");
            nguoiNhans.Columns.Add("TENTCTT");

            nguoiNhan.Columns.Add("TUCACHTOTUNG_MA");
            nguoiNhan.Columns.Add("TONGDAT_DOITUONG");
            nguoiNhan.Columns.Add("TENDUONGSU");
            nguoiNhan.Columns.Add("TENTCTT");
            DataRow nguoiNhanRow = nguoiNhan.Rows[0];

            string nguoiNhanName = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(nguoiNhanRow["ID"]));
            nguoiNhanRow["TONGDAT_DOITUONG"] = nguoiNhanRow["ID"];
            nguoiNhanRow["ID"] = nguoiNhanRow["DUONGSUID"];
            nguoiNhanRow["TUCACHTOTUNG_MA"] = nguoiNhanRow["MATUCACH"];
            nguoiNhanRow["TENDUONGSU"] = nguoiNhanName;
            nguoiNhanRow["TENTCTT"] = nguoiNhanRow["MATUCACH"];

            foreach (DataRow row in nguoiNhans.Rows)
            {
                string name = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(row["ID"]));
                row["TONGDAT_DOITUONG"] = row["ID"];
                row["ID"] = row["DUONGSUID"];
                row["TUCACHTOTUNG_MA"] = row["MATUCACH"];
                row["TENDUONGSU"] = name;
                row["TENTCTT"] = row["MATUCACH"];
            }
            nguoiNhans = Sort(nguoiNhans);
            // vnpt 03/12/2025
            if (nguoiNhans != null)
            {
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    Sothongbao.Value = row["SOTHONGBAO"].ToString();
                }
            }
            nguoiNhans.Rows.Add(nguoiNhanRow.ItemArray);
            //Set ngày gửi là ngày hiện tại
            if (nguoiNhans != null)
            {
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                    {
                        row["NGAYGUI"] = DateTime.Now;
                    }
                }
            }
            dgTructiep.DataSource = nguoiNhans;
            dgTructiep.DataBind();
            for (int i = 0; i < dataCount + 1; i++)
            {
                ((Button)dgTructiep.Items[i].FindControl("btn_insert")).Visible = false;
                ((Button)dgTructiep.Items[i].FindControl("btn_remove")).Visible = false;
                if (i < dataCount)
                {
                    dgTructiep.Items[i].Enabled = false;
                }
            }
            trDuongsu.Visible = true;
            dgTructiep.Visible = true;
            if (FILEID > 0)
            {
                lbtDownload.Visible = true;
                hddFile.Value = FILEID + "";
            }
            else
                lbtDownload.Visible = false;
        }

        public void loadPhatHanhBoSung(decimal ID)
        {
            cmdLammoi.Visible = true;
            bool IsShowVKS = false;
            trThemFile.Visible = false;
            decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
            DateTime? IS_TD_VKS_NGAY = null;
            AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
            decimal? MapID = 0;
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
                FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
                MapID = oND.MAPID;
            }
            ddlBieumau.Visible = false;
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
            if (oBM != null)
            {
                string sothongbao = "";
                DateTime? ngaythongbao = null;
                string BM_THONGBAO = "";
                if (MapID != null && MapID != 0)
                {
                    AKT_ANPHI aDS_ANPHI = dt.AKT_ANPHI.Where(x => x.ID == MapID).FirstOrDefault();
                    DON_MIENANPHI_BL dON_MIENANPHI = new DON_MIENANPHI_BL();

                    if (aDS_ANPHI != null)
                    {
                        DataTable DON_MIENANPHI = dON_MIENANPHI.GET_DON_MIENANPHI_BY_ANPHI_ID(aDS_ANPHI.ID, 4);
                        sothongbao = DON_MIENANPHI.Rows.Count > 0 ? DON_MIENANPHI.Rows[0]["SOTHONGBAO"].ToString() + DON_MIENANPHI.Rows[0]["STB_PHU"] : aDS_ANPHI.SOTHONGBAO + aDS_ANPHI.STB_PHU;
                        ngaythongbao = DON_MIENANPHI.Rows.Count > 0 ? Convert.ToDateTime(DON_MIENANPHI.Rows[0]["NGAYTHONGBAO"]) : aDS_ANPHI.NGAYTHONGBAO;
                    }

                    BM_THONGBAO = sothongbao != "" ? " (Số thông báo: " + sothongbao + " - Ngày: " + GetTextDate(ngaythongbao) + ")" : "";
                }

                lstTenBM.Text = oBM.TENBM + BM_THONGBAO;
                ddlBieumau.Items.Clear();
                ddlBieumau.Items.Add(new ListItem(oBM.MABM + " " + oBM.TENBM + BM_THONGBAO, oBM.ID.ToString() + "_" + MapID));
                ddlBieumau.SelectedIndex = 0;
            }
            if (IS_TD_VKS == 1)
            {
                //IsShowVKS = true;
                rdbIsVKS.SelectedValue = "1";
                lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
                txtVKS_Ngaygui.Enabled = txtVKS_NgayNhan.Enabled = false;

                txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? null : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
                txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);

                if (txtVKS_Ngaygui.Text != null && txtVKS_Ngaygui.Text != "")
                    rdbIsVKS.Enabled = false;
                else
                    rdbIsVKS.Enabled = true;
            }
            else
            {
                rdbIsVKS.SelectedValue = "0";
                txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
            }
            cmdLammoi.Visible = true;
            BL.GSTP.AKT.AKT_TONGDAT_BL TONGDATBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            DataTable nguoiNhans = null;
            if (oBM.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí  
            {
                nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(ID);
            }
            else
            {
                nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(ID);
            }
            nguoiNhans.Columns.Add("TUCACHTOTUNG_MA");
            nguoiNhans.Columns.Add("TONGDAT_DOITUONG");
            nguoiNhans.Columns.Add("TENDUONGSU");
            nguoiNhans.Columns.Add("TENTCTT");
            foreach (DataRow row in nguoiNhans.Rows)
            {
                string name = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(row["ID"]));
                row["TONGDAT_DOITUONG"] = row["ID"];
                row["ID"] = row["DUONGSUID"];
                row["TUCACHTOTUNG_MA"] = row["MATUCACH"];
                row["TENDUONGSU"] = name;
                row["TENTCTT"] = row["MATUCACH"];
                Sothongbao.Value = row["SOTHONGBAO"].ToString(); // vnpt 03/12/2025
            }
            int cnt = nguoiNhans.Rows.Count;
            var newRow = nguoiNhans.NewRow();
            nguoiNhans.Rows.Add(newRow);
            nguoiNhans = Sort(nguoiNhans);
            //Set ngày gửi là ngày hiện tại
            if (nguoiNhans != null)
            {
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                    {
                        row["NGAYGUI"] = DateTime.Now;
                    }
                }
            }
            dgTructiep.DataSource = nguoiNhans;
            dgTructiep.DataBind();
            loadBangPHBS(cnt);
            trDuongsu.Visible = true;
            dgTructiep.Visible = true;
            if (FILEID > 0)
            {
                lbtDownload.Visible = true;
                hddFile.Value = FILEID + "";
            }
            else
                lbtDownload.Visible = false;
        }

        private void loadBangPHBS(int cnt)
        {
            for (int i = 0; i < cnt; i++)
            {
                DataGridItem Item = dgTructiep.Items[i];
                string trangThaiDoiTuong = Item.Cells[23].Text;
                Item.Enabled = false;
            }
        }

        private void loadBangSua(int cnt)
        {
            for (int i = 0; i < cnt; i++)
            {
                DataGridItem Item = dgTructiep.Items[i];
                //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEID
                string trangThaiDoiTuong = Item.Cells[25].Text;
                if (trangThaiDoiTuong != "0" && trangThaiDoiTuong != "2")
                {
                    Item.Enabled = false;
                    Button btn_remove = Item.FindControl("btn_remove") as Button;
                    Button btn_insert = Item.FindControl("btn_insert") as Button;
                    btn_insert.Visible = false;
                    btn_remove.Visible = false;
                }
            }
        }

        //public void loadedit(decimal ID)
        //{
        //    cmdLammoi.Visible = true;
        //    bool IsShowVKS = false;
        //    trThemFile.Visible = false;
        //    decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
        //    DateTime? IS_TD_VKS_NGAY = null;
        //    AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
        //    if (oND != null)
        //    {
        //        hddid.Value = oND.ID.ToString();
        //        BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
        //        IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
        //        IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
        //        FILEID = oND.FILEID + "" == "" ? 0 : (decimal)oND.FILEID;
        //    }
        //    ddlBieumau.Visible = false;
        //    DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
        //    if (oBM != null)
        //    {
        //        lstTenBM.Text = oBM.TENBM;
        //        ddlBieumau.Items.Clear();
        //        ddlBieumau.Items.Add(new ListItem(oBM.MABM + " " + oBM.TENBM, oBM.ID.ToString()));
        //        ddlBieumau.SelectedIndex = 0;
        //    }
        //    if (IS_TD_VKS == 1)
        //    {
        //        //IsShowVKS = true;
        //        rdbIsVKS.SelectedValue = "1";
        //        lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
        //        txtVKS_Ngaygui.Enabled = txtVKS_NgayNhan.Enabled = false;

        //        txtVKS_Ngaygui.Text = IS_TD_VKS_NGAY + "" == "" ? null : ((DateTime)IS_TD_VKS_NGAY).ToString("dd/MM/yyyy", cul);
        //        txtVKS_NgayNhan.Text = oND.NGAYNHANTONGDAT + "" == "" ? "" : ((DateTime)oND.NGAYNHANTONGDAT).ToString("dd/MM/yyyy", cul);

        //        if (txtVKS_Ngaygui.Text != null && txtVKS_Ngaygui.Text != "")
        //            rdbIsVKS.Enabled = false;
        //        else
        //            rdbIsVKS.Enabled = true;
        //    }
        //    else
        //    {
        //        rdbIsVKS.SelectedValue = "0";
        //        txtVKS_Ngaygui.Text = txtVKS_NgayNhan.Text = "";
        //    }
        //    LoadDoituong(IsShowVKS, BIEUMAUID);
        //    if (FILEID > 0)
        //    {
        //        //AKT_FILE oF = dt.AKT_FILE.Where(x => x.ID == FILEID).FirstOrDefault();
        //        //if (oF != null) {
        //        //    if (oF.TENFILE !=null)
        //        //        lbtDownload.Visible = true;
        //        //    else
        //        //        lbtDownload.Visible = false;
        //        //}
        //        lbtDownload.Visible = true;
        //        //lbtDownload.Text = oND.TENFILE;
        //        hddFile.Value = FILEID + "";
        //    }
        //    else
        //        lbtDownload.Visible = false;

        //    ////Xem Van thu da tong dat(Ngay tong dat not null) thi khong duoc sưa
        //    //List<AKT_TONGDAT_DOITUONG> lst = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == ID).ToList();
        //    //int vCheck = 0;
        //    //if (lst.Count > 0)
        //    //{
        //    //    for (int i = 0; i < lst.Count(); i++)
        //    //    {
        //    //        if (lst[i].TRANGTHAI == 1 && lst[i].NGAYGUI != null)
        //    //        {
        //    //            vCheck++;
        //    //        }
        //    //    }
        //    //    if (vCheck > 0)
        //    //    {
        //    //        cmdUpdate.Enabled = false;
        //    //        return;
        //    //    }
        //    //}
        //}

        protected void loadAction(string nDID)
        {
            string[] splitStr = nDID.Split('#');
            decimal TrangThai = Convert.ToDecimal(splitStr[0]);
            decimal ID = Convert.ToDecimal(splitStr[1]);
            decimal TongdatID = Convert.ToDecimal(splitStr[2]);

            //if (TrangThai == 1) //Thu hồi đối tượng
            //{
            //    if (string.IsNullOrEmpty(txbNgayThuHoi.Text) || string.IsNullOrEmpty(txtLyDoThuHoi.Text))
            //    {
            //        lbThongBaoThuHoi.Text = "Ngày thu hồi và lý do thu hồi không được để trống";
            //        lbthongbao.Text = "";
            //        return;
            //    }
            //    DateTime NgayThuHoi;
            //    try
            //    {
            //        NgayThuHoi = (String.IsNullOrEmpty(txbNgayThuHoi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txbNgayThuHoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    }
            //    catch
            //    {
            //        lbThongBaoThuHoi.Text = "Ngày thu hồi không hợp lý";
            //        lbthongbao.Text = "";
            //        return;
            //    }
            //    string LyDoThuHoi = txtLyDoThuHoi.Text;
            //    List<decimal> tongDatIds = new List<decimal>();
            //    tongDatIds.Add(TongdatID);
            //    string NguoiSua = "" + Session[ENUM_SESSION.SESSION_USERNAME];

            //    //Call package
            //    BL.GSTP.AKT.AKT_TONGDAT_BL tongDatBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            //    tongDatBL.AKT_TONGDAT_THUHOI_DOITUONG(ID, TongdatID, LyDoThuHoi, NgayThuHoi, NguoiSua);

            //    //Call api thu hồi
            //    try
            //    {
            //        string result = CallApiThuhoi(tongDatIds, LyDoThuHoi, NgayThuHoi, NguoiSua);
            //        JToken jObject = JToken.Parse(result);
            //        if ((string)jObject["status"] == "SUCCESS")
            //        {
            //            lbThongBaoThuHoi.Text = "Thu hồi thành công !";
            //        }
            //        else
            //        {
            //            lbThongBaoThuHoi.Text = "Thu hồi thất bại !";
            //        }
            //    }
            //    catch (Exception)
            //    {
            //        lbThongBaoThuHoi.Text = "Gửi sang VBĐH thất bại do không thể gọi api !";
            //    }

            //    lbthongbao.Text = "";
            //    txbNgayThuHoi.Text = txtLyDoThuHoi.Text = "";
            //    dgList.DataBind();
            //    LoadGrid();
            //}

            if (TrangThai == 2) // Xem lý do thu hồi
            {
                TONGDAT_BL oBL = new TONGDAT_BL();
                DataTable objLyDo = oBL.GET_LYDO_THUHOI(4, TongdatID);
                if (objLyDo != null)
                {
                    txbNgayThuHoi.Text = objLyDo.Rows[0]["NGAYTHUHOI"].ToString();
                    txtLyDoThuHoi.Text = objLyDo.Rows[0]["LYDOTHUHOI"].ToString();
                }
            }
            else if (TrangThai == 3) //VBĐH
            {
                BL.GSTP.AKT.AKT_TONGDAT_BL tongDatBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
                tongDatBL.AKT_TONGDAT_VBDH_DOITUONG(ID);
                LoadGrid();
            }
            else if (TrangThai == 5)
            {
                loadPhatHanhLai(TongdatID, ID);
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string ND_id = e.CommandArgument.ToString();
            switch (e.CommandName)
            {
                case "action":
                    lbthongbao.Text = "";
                    loadAction(ND_id);
                    //hddid.Value = e.CommandArgument.ToString();
                    CountItem.Value = dgTructiep.Items.Count.ToString();
                    break;
                case "Download":
                    //---------08/05/2025----
                    decimal tongDatId = Convert.ToDecimal(ND_id);
                    AKT_TONGDAT ads = dt.AKT_TONGDAT.Where(x => x.ID == tongDatId).FirstOrDefault();
                    byte[] conten=null;
                    if (ads != null)
                    {
                        if (ads.URL_FILE != null)
                        {
                            string strFilePath = ads.URL_FILE;
                            string vfileNam = Path.GetFileName(strFilePath).Replace(" ", "_");
                            ////Cach goi các API làm việc với MinIO
                            var authService = new AuthService();
                            string token = authService.AuthenticateAsync().GetAwaiter().GetResult();
                            if (!string.IsNullOrEmpty(token))
                            {
                                Console.WriteLine("✅ Token: " + token);
                                string vNameBuket = System.Configuration.ConfigurationManager.AppSettings["NameBuket"];
                                //Tai file client 
                                conten = CallApiMinIO.DownloadFileAsync_file(token, ads.URL_FILE, vNameBuket).GetAwaiter().GetResult();
                                if (conten != null)
                                {
                                    Load_Respon_File(vfileNam, conten);
                                }
                            }
                            else
                            {
                                Console.WriteLine("❌ Đăng nhập thất bại.");
                            }
                        }
                        if (ads.URL_FILE == null || conten == null)
                        {
                            AKT_FILE oF = dt.AKT_FILE.Where(x => x.ID == ads.FILEID).FirstOrDefault();
                            if (oF != null)
                            {
                                if (oF.TENFILE != null)
                                {
                                    Load_Respon_File(oF.TENFILE, oF.NOIDUNG);
                                }
                            }
                        }
                    }                   
                    break;
                case "UpdateNgayNhan":
                    lbthongbao.Text = "";
                    string strMsg = "";
                    decimal Id_obj = Convert.ToDecimal(ND_id);                  
                    TextBox txtNGAYNHANTONGDAT = (TextBox)e.Item.FindControl("txtNGAYNHANTONGDAT");
                    DateTime INPUT_NGAYNHANTONGDAT;
                    TONGDAT_BL obj = new TONGDAT_BL();
                    if (txtNGAYNHANTONGDAT.Text != "")
                    {
                        bool isValidate = DateTime.TryParse(txtNGAYNHANTONGDAT.Text, cul, DateTimeStyles.NoCurrentDateDefault, out INPUT_NGAYNHANTONGDAT);
                        if (!isValidate)
                        {
                            strMsg = "Ngày nhận tống đạt không đúng kiểu ngày / tháng / năm. Hãy nhập lại.";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            txtNGAYNHANTONGDAT.Text = string.Empty;
                            return;
                        }
                        if (DateTime.Compare(DateTime.Now, INPUT_NGAYNHANTONGDAT) < 0)
                        {
                            strMsg = "Ngày nhận tống đạt không được lớn hơn ngày hiện tại";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            txtNGAYNHANTONGDAT.Text = string.Empty;
                            return;
                        }
                        if (obj.TONGDAT_DOITUONG_VNID(Id_obj, "4", txtNGAYNHANTONGDAT.Text) == true)
                        {
                            strMsg = "Bạn đã cập nhật thành công";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            LoadGrid();
                        }
                    }
                    else if (txtNGAYNHANTONGDAT.Text == "")
                    {
                        //INPUT_NGAYNHANTONGDAT=DateTime.Parse(txtNGAYNHANTONGDAT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        if (obj.TONGDAT_DOITUONG_VNID(Id_obj, "4", null) == true)
                        {
                            strMsg = "Bạn đã cập nhật thành công";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            LoadGrid();
                        }

                        //strMsg = "Bạn chưa nhập ngày nhận tống đạt";
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        //return;
                    }
                    break;
            }
        }
        void Load_Respon_File(String _FILE_NAME, byte[] b)
        {
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }
        #region "PHÂN TRANG"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion

        private void LoadDoituong(bool IsShowVKS, decimal BieuMauID)
        {
            //trVKS.Visible = false;
            trDuongsu.Visible = false;
            decimal BMID = 0, IS_TD_DUONGSU = 0, IS_TD_VKS = 0, IS_TD_NGUYENDON = 0;
            decimal ANPHI_ID = 0;
            //---------01/12/2025----  vnpt chỉnh lấy thêm FILEID
            decimal FILEID = -1;
            if (BieuMauID == 0)
            {
                if (ddlBieumau.SelectedValue == "0")
                {
                    return;
                }
                //decimal IDFILE = Convert.ToDecimal(ddlBieumau.SelectedValue);
                //AKT_FILE oF = dt.AKT_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
                //if (oF != null) BMID = oF.BIEUMAUID + "" == "" ? 0 : (decimal)oF.BIEUMAUID;
                //if (IDFILE == -1) BMID = 230;
                //if (IDFILE == -2) BMID = 261;

                BMID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                ANPHI_ID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[1]);
                //---------21/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                if (ddlBieumau.SelectedValue.Split('_').Length > 2)
                {
                    FILEID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[2]);
                }
            }
            else
            {
                BMID = BieuMauID;
            }
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BMID).FirstOrDefault();
            if (oBM != null)
            {
                IS_TD_VKS = oBM.IS_TD_VKS + "" == "" ? 0 : (decimal)oBM.IS_TD_VKS;
                IS_TD_DUONGSU = oBM.IS_TD_DUONGSU + "" == "" ? 0 : (decimal)oBM.IS_TD_DUONGSU;
                IS_TD_NGUYENDON = oBM.IS_TD_NGUYENDON + "" == "" ? 0 : (decimal)oBM.IS_TD_NGUYENDON;
            }

            AKT_DON_BL oBL = new AKT_DON_BL();
            string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oDTDS = null;
            if (hddIsTructuyen.Value == "1")
            {
                trTructuyen.Visible = true;
            }
            if (IS_TD_DUONGSU == 1)
            {
                if (oBM.MABM == "100-DS")
                {
                    oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 0, ANPHI_ID);
                }
                else
                {
                    oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 0, FILEID);
                }
                    
                trDuongsu.Visible = true;
            }
            else if (IS_TD_NGUYENDON == 1 && IS_TD_DUONGSU != 1)
            {
                if (oBM.MABM == "100-DS")
                {
                    oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 1, ANPHI_ID);
                }
                else
                {
                    oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 0, FILEID);
                }
                
                trDuongsu.Visible = true;
            }
            if (trDuongsu.Visible)
            {
                if (hddIsTructuyen.Value == "1")
                {
                    DataTable dtTructuyen = CreateTable();
                    DataTable dtTructiep = CreateTable();
                    string strarrOnline = "," + hddarrDuongsuTructuyen.Value + ",";
                    foreach (DataRow r in oDTDS.Rows)
                    {
                        string strDSID = r["ID"] + "";
                        if (strarrOnline.Contains("," + strDSID + ","))
                        {//Online
                            DataRow rOnline = dtTructuyen.NewRow();
                            rOnline["ID"] = r["ID"];
                            rOnline["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                            rOnline["TENDUONGSU"] = r["TENDUONGSU"];
                            rOnline["TRANGTHAI"] = r["TRANGTHAI"];
                            rOnline["NGAYGUI"] = r["NGAYGUI"];
                            rOnline["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                            rOnline["TENTCTT"] = r["TENTCTT"];

                            rOnline["ANPHI_ID"] = r["ANPHI_ID"];
                            rOnline["SOTHONGBAO"] = r["SOTHONGBAO"];
                            rOnline["MA_THONGBAO"] = r["MA_THONGBAO"];
                            Sothongbao.Value = r["SOTHONGBAO"]?.ToString(); // vnpt 03/12/2025
                            dtTructuyen.Rows.Add(rOnline);
                        }
                        else
                        {
                            DataRow rTructiep = dtTructiep.NewRow();
                            rTructiep["ID"] = r["ID"];
                            rTructiep["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                            rTructiep["TENDUONGSU"] = r["TENDUONGSU"];
                            rTructiep["TRANGTHAI"] = r["TRANGTHAI"];
                            rTructiep["NGAYGUI"] = r["NGAYGUI"];
                            rTructiep["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                            rTructiep["TENTCTT"] = r["TENTCTT"];
                            rTructiep["HINHTHUCGUI"] = r["HINHTHUCGUI"];
                            rTructiep["DIACHI"] = r["DIACHI"];
                            rTructiep["NGAYPHATHANH"] = r["NGAYPHATHANH"];
                            rTructiep["NOINHAN"] = r["NOINHAN"];
                            rTructiep["QUOCGIA"] = r["QUOCGIA"];
                            rTructiep["COQUAN"] = r["COQUAN"];
                            rTructiep["NOIDUNG"] = r["NOIDUNG"];
                            rTructiep["DUONGSUID"] = r["DUONGSUID"];
                            rTructiep["KETQUAUTTP"] = r["KETQUAUTTP"];
                            rTructiep["TONGDAT_DOITUONG"] = r["TONGDAT_DOITUONG"];

                            rTructiep["ANPHI_ID"] = r["ANPHI_ID"];
                            rTructiep["SOTHONGBAO"] = r["SOTHONGBAO"];
                            rTructiep["MA_THONGBAO"] = r["MA_THONGBAO"];
                            Sothongbao.Value = r["SOTHONGBAO"]?.ToString(); // vnpt 03/12/2025
                            dtTructiep.Rows.Add(rTructiep);
                        }
                    }

                    dgTructiep.DataSource = dtTructiep;
                    dgTructiep.DataBind();
                    CountItem.Value = dtTructiep.Rows.Count.ToString();
                    dgTructuyen.DataSource = dtTructuyen;
                    dgTructuyen.DataBind();
                }
                else
                {
                    //Set ngày gửi là ngày hiện tại
                    if (oDTDS != null)
                    {
                        foreach (DataRow row in oDTDS.Rows)
                        {
                            if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                            {
                                row["NGAYGUI"] = DateTime.Now;
                            }
                            Sothongbao.Value = row["SOTHONGBAO"].ToString(); // vnpt 03/12/2025
                        }
                    }
                    dgTructiep.DataSource = oDTDS;
                    CountItem.Value = oDTDS.Rows.Count.ToString();

                    dgTructiep.DataBind();
                }
            }
            if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
            if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
        }

        private void DataCombox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            var dataketquauttp = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME("KETQUAUT");
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                ddlketquauttp.Items.Clear();
                ddlketquauttp.SelectedValue = null;
                ddlQuocGiaUT.Items.Clear();
                ddlQuocGiaUT.SelectedValue = null;
                ddlQuocGiaUT.DataSource = dtQuoctich;
                ddlQuocGiaUT.DataTextField = "TEN";
                ddlQuocGiaUT.DataValueField = "ID";
                ddlQuocGiaUT.DataBind();
                ddlQuocGiaUT.Items.Insert(0, new ListItem("--Chọn--", "0"));
                ddlketquauttp.DataSource = dataketquauttp;
                ddlketquauttp.DataTextField = "TEN";
                ddlketquauttp.DataValueField = "ID";
                ddlketquauttp.DataBind();
                ddlketquauttp.Items.Insert(0, new ListItem("--Chọn--", "0"));

                ddlketquauttp.ToolTip = Item.Cells[0].Text;
            }
        }

        private DataTable CreateTable()
        {
            DataTable oDT = new DataTable();
            oDT.Columns.Add(new DataColumn("ID", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("TUCACHTOTUNG_MA", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("TENDUONGSU", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("DUONGSUID", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("TRANGTHAI", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("NGAYGUI", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("NGAYNHANTONGDAT", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("TENTCTT", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("HINHTHUCGUI", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("NOINHAN", Type.GetType("System.String")));
            #region Thiều 
            oDT.Columns.Add(new DataColumn("QUOCGIA", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("COQUAN", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("NOIDUNG", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("KETQUAUTTP", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("DIACHI", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("NGAYPHATHANH", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("TONGDAT_DOITUONG", Type.GetType("System.Decimal")));

            #endregion

            #region VNPT Án phí
            oDT.Columns.Add(new DataColumn("ANPHI_ID", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("SOTHONGBAO", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("MA_THONGBAO", Type.GetType("System.String")));
            #endregion

            oDT.AcceptChanges();
            return oDT;
        }

        protected void ddlBieumau_SelectedIndexChanged(object sender, EventArgs e)
        {

            lbthongbao.Text = "";
            trThemFile.Visible = false;
            LoadDoituong(false, 0);
            DataCombox();
            lbtDownload.Visible = false;

            if (ddlBieumau.SelectedValue != "0")
            {
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                string id_anphi_id = ddlBieumau.SelectedValue;
                decimal bieu_mau_id = Convert.ToDecimal(id_anphi_id.Split('_')[0]);

                ListItem item = ddlBieumau.Items.FindByValue(id_anphi_id);
                //---------21/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                AKT_FILE oF = new AKT_FILE();
                if (ddlBieumau.SelectedValue.Split('_').Length > 2)
                {
                    decimal FILEID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[2]);
                    oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id && x.ID == FILEID).FirstOrDefault();
                }
                else
                {
                    oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id).FirstOrDefault();
                }
                if (oF != null)
                {
                    if (oF.TENFILE == null)
                    {
                        if (trTructuyen.Visible)
                        {
                            //manhnd Van thu se dinh kem. Thu ky chi hien thi
                            //lbthongbao.Text = "Biểu mẫu chưa được đính kèm file để tống đạt trực tuyến !";
                            //trThemFile.Visible = true;
                            lbtDownload.Visible = false;
                        }
                        return;
                    }
                    else
                    {
                        lbtDownload.Visible = true;
                        hddFile.Value = oF.ID.ToString();
                    }
                }
            }
        }

        protected void chkIsSend_CheckChange(object sender, EventArgs e)
        {

            foreach (DataGridItem item in dgTructiep.Items)
            {
                CheckBox chkIsSendTT = (CheckBox)item.FindControl("chkIsSend");
                DropDownList ddlHinhthuc = (DropDownList)item.FindControl("ddlHinhthuc");
                if (chkIsSendTT.Checked == true)
                {
                    ddlHinhthuc.Visible = true;
                }
                else
                {
                    ddlHinhthuc.Visible = false;
                }
            }
            //Manhnd bo 04/8/2021 Thư ky chi xac nhan se tong dat cho ai. còn Van thu se nhap ngay Tong dat
            //CheckBox chk = (CheckBox)sender;
            //IsHideColumn = true;
            //foreach (DataGridItem Item in dgTructiep.Items)
            //{
            //    CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
            //    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
            //    TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
            //    DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");

            //    #region Thiều 
            //    DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
            //    DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
            //    TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
            //    TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
            //    Label lblQuocGia = (Label)Item.FindControl("lblQuocGia");
            //    Label lblNoidung = (Label)Item.FindControl("lblNoidung");
            //    Label lblCoquan = (Label)Item.FindControl("lblCoquan");
            //    #endregion

            //    kiểm tra
            //    string vHINHTHUCGUI = ddlHinhthucgui.SelectedValue;
            //    if (Item.Cells[0].Text.Equals(chk.ToolTip))
            //    {
            //        if (chk.Checked)
            //        {
            //            ddlHinhthucgui.Visible = ddlHinhthucgui.Enabled = true;
            //            if (ddlHinhthucgui.SelectedValue == "5")
            //            {
            //                txtNgaygui.Enabled = true;
            //                txtNgayNhan.Enabled = true;
            //            }
            //            else
            //                txtNgaygui.Enabled = txtNgayNhan.Enabled = false;
            //            if (txtNgaygui.Text == "")
            //                txtNgaygui.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //            #region Thiều 
            //            if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
            //            {
            //                IsHideColumn = false;
            //                ddlQuocGiaUT.Visible = true;
            //                ddlketquauttp.Visible = true;
            //                txtCoquan.Visible = true;
            //                txtNoidung.Visible = true;
            //                lblQuocGia.Visible = true;
            //                lblNoidung.Visible = true;
            //                lblCoquan.Visible = true;
            //                txtNgaygui.Enabled = true;
            //                txtNgayNhan.Enabled = true;
            //            }
            //            else
            //            {
            //                ddlQuocGiaUT.Visible = false;
            //                ddlketquauttp.Visible = false;
            //                txtCoquan.Visible = false;
            //                txtNoidung.Visible = false;

            //                lblQuocGia.Visible = false;
            //                lblNoidung.Visible = false;
            //                lblCoquan.Visible = false;

            //                txtNgaygui.Enabled = false;
            //                txtNgayNhan.Enabled = false;
            //            }
            //        }
            //        else
            //        {
            //            txtNgaygui.Enabled = txtNgayNhan.Enabled = false;
            //            ddlHinhthucgui.Visible = ddlHinhthucgui.Enabled = false;

            //            ddlQuocGiaUT.Visible = false;
            //            ddlketquauttp.Visible = false;
            //            txtCoquan.Visible = false;
            //            txtNoidung.Visible = false;

            //            lblQuocGia.Visible = false;
            //            lblNoidung.Visible = false;
            //            lblCoquan.Visible = false;

            //            txtNgaygui.Enabled = false;
            //            txtNgayNhan.Enabled = false;

            //            txtNgaygui.Text = "";
            //            txtNgayNhan.Text = "";
            //            ddlHinhthucgui.SelectedValue = "2";
            //            ddlQuocGiaUT.SelectedIndex = 0;
            //            txtCoquan.Text = "";
            //            txtNoidung.Text = "";
            //            ddlketquauttp.SelectedIndex = 0;
            //        }
            //        #endregion
            //    }
            //    else
            //    {
            //        lúc sửa
            //        if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
            //        {
            //            IsHideColumn = false;
            //        }
            //    }
            //}

            //#region Thiều
            //if (!chk.Checked)
            //{
            //    DataGrid dtt = dgTructiep;
            //    if (IsHideColumn)
            //    {
            //        dtt.Columns[15].Visible = false;
            //        dtt.Columns[16].Visible = false;
            //        check = 0;
            //        IsHideColumn = false;
            //    }
            //    else if (!IsHideColumn)
            //    {
            //        dtt.Columns[15].Visible = true;
            //        dtt.Columns[16].Visible = true;
            //        check = 0;
            //        IsHideColumn = false;
            //    }
            //}
            // #endregion
        }

        protected void rdbIsVKS_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtVKS_Ngaygui.Visible = lblVKSNgaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = rdbIsVKS.SelectedValue == "1" ? true : false;
            //if (rdbIsVKS.SelectedValue == "1" && txtVKS_Ngaygui.Text == "") txtVKS_Ngaygui.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);
                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }

        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal IDFILE = Convert.ToDecimal(hddFile.Value);
            AKT_FILE oF = dt.AKT_FILE.Where(x => x.ID == IDFILE).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE != null)
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                }
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            BL.GSTP.AKT.AKT_TONGDAT_BL aKT = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownload"));
                //DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lbtn = (LinkButton)e.Item.FindControl("lbtn");

                TextBox txtNGAYNHANTONGDAT = (TextBox)e.Item.FindControl("txtNGAYNHANTONGDAT");
                //------------------01/12/2025 vnpt check xacThuc
                decimal? xacThuc;
                try
                {
                    xacThuc = Convert.ToDecimal(e.Item.Cells[6].Text);
                }
                catch
                {
                    xacThuc = null;
                }
                Button cmdUpdate_NgayNhan = (Button)e.Item.FindControl("cmdUpdate_NgayNhan");

                var cb_thuhoi = (CheckBox)e.Item.FindControl("cb_thuhoi");
                //string toagiaiquyetID = e.Item.Cells[18].Text.Trim();
                //string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                //if (toagiaiquyetID != donviID)
                //{
                //    cb_thuhoi.Visible = false;
                //}


                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal? duongsu_id;
                try
                {
                    duongsu_id = Convert.ToDecimal(e.Item.Cells[2].Text);
                }
                catch
                {
                    duongsu_id = null;
                }
                decimal id = Convert.ToDecimal(e.Item.Cells[0].Text);
                Label lbNoiNhan = (Label)e.Item.FindControl("lbNoiNhan");
                decimal tongdatID = Convert.ToDecimal(e.Item.Cells[1].Text);
                string TenBM = aKT.AKT_TENBM_GETBYTONGDATID(tongdatID);
                Label lbTenBM = (Label)e.Item.FindControl("lbTenBM");
                lbTenBM.Text = TenBM;
                lbNoiNhan.Text = aKT.AKT_TONGDATDOITUONG_GETTENDUONGSU(id);
                if (duongsu_id != null)
                {
                }

                //Icon file đính kèm
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                BL.GSTP.AKT.AKT_TONGDAT_BL Bl = new BL.GSTP.AKT.AKT_TONGDAT_BL();
                AKT_TONGDAT_GS oND = convertToAKT_TONGDATFromDataTable(Bl.AKT_TONGDAT_GETBYID(tongdatID)).FirstOrDefault();
                lblDownload.ToolTip = oND.TENFILE;
                if (oND.URL_FILE + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }

                decimal DONID = Convert.ToDecimal(current_id);
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                    {  
                        //VNPT  04/12/2025

                        if (lblSua != null)
                        {
                            lblSua.Text = "Xem chi tiết";
                        }
                        if (lbtXoa != null)
                        {
                            lbtXoa.Visible = false;
                        }
                        
                    }
                }
                int rowspan = aKT.AKT_TONGDATDOITUONG_GETBYTONGDATID(tongdatID).Rows.Count;
                e.Item.Cells[7].RowSpan = rowspan; // TEN BIEU MAU
                e.Item.Cells[6].RowSpan = rowspan; // TT

                Label lbTT = (Label)e.Item.FindControl("lbTT");

                e.Item.Cells[5].RowSpan = rowspan; // CHECKBOX
                int curIndex = e.Item.ItemIndex;
                if (curIndex == 0)
                {
                    lbTT.Text = "1";
                }
                else if (curIndex > 0)
                {
                    var preItem = dgList.Items[curIndex - 1];
                    decimal preTongDatID = Convert.ToDecimal(preItem.Cells[1].Text);
                    Label prelbTT = (Label)preItem.FindControl("lbTT");
                    if (preTongDatID == tongdatID)
                    {
                        e.Item.Cells[7].Visible = false;
                        e.Item.Cells[6].Visible = false;
                        e.Item.Cells[5].Visible = false;
                        lbTT.Text = (Convert.ToDecimal(prelbTT.Text)).ToString();
                    }
                    else
                    {
                        lbTT.Text = (Convert.ToDecimal(prelbTT.Text) + 1).ToString();
                    }

                }
                decimal trangThai = Convert.ToDecimal(e.Item.Cells[4].Text);
                Label lbTrangThai = (Label)e.Item.FindControl("lbTrangThai");
                //------------------01/12/2025 vnpt check xacThuc
                Label lbVNeID = (Label)e.Item.FindControl("lbVNeID");

                HiddenField Hi_column_value = (HiddenField)e.Item.FindControl("Hi_column_value");
                String[] ND_id_arr = Hi_column_value.Value.Split(';');

                string V_NGAYGUI = ND_id_arr[0] + "";
                string V_NGAYPHATHANH = ND_id_arr[1] + "";//10/01/2025
                string V_HINHTHUCGUI = ND_id_arr[2] + "";//10/01/2025
                Label lbtHinhthucgui = (Label)e.Item.FindControl("lbtHinhthucgui");
                //26/04/2025---------------
                txtNGAYNHANTONGDAT.Enabled = false;
                cmdUpdate_NgayNhan.Enabled = false;
                txtNGAYNHANTONGDAT.CssClass = "user txt_ngay_nhan_Dis";
                cmdUpdate_NgayNhan.CssClass = "buttoninput btn_ngaynhan_Dis";
                //----------//10/01/2025--------
                if (V_HINHTHUCGUI == "0")
                {
                    lbtHinhthucgui.Text = "Trực tiếp";
                    txtNGAYNHANTONGDAT.Enabled = true;
                    cmdUpdate_NgayNhan.Enabled = true;
                    txtNGAYNHANTONGDAT.CssClass = "user txt_ngay_nhan";
                    cmdUpdate_NgayNhan.CssClass = "buttoninput btn_ngaynhan";
                }
                if (V_HINHTHUCGUI == "1")
                {
                    lbtHinhthucgui.Text = "Thừa phát lại";
                }
                if (V_HINHTHUCGUI == "2")
                {
                    lbtHinhthucgui.Text = "Qua bưu điện";
                }
                if (V_HINHTHUCGUI == "5")
                {
                    lbtHinhthucgui.Text = "Niêm yết công khai";
                    txtNGAYNHANTONGDAT.Enabled = true;
                    cmdUpdate_NgayNhan.Enabled = true;
                    txtNGAYNHANTONGDAT.CssClass = "user txt_ngay_nhan";
                    cmdUpdate_NgayNhan.CssClass = "buttoninput btn_ngaynhan";
                }
                //------------------
                if (trangThai == 0)
                {
                    lbTrangThai.Text = "Chưa gửi";
                    lbtn.Text = "";
                }
                else if (trangThai == 1)
                {
                    lbTrangThai.Text = "Đã gửi";
                    lbtn.Text = "";
                }
                else if (trangThai == 2)
                {
                    lbTrangThai.Text = "Đã thu hồi";
                    lbTrangThai.CssClass = "red-text";
                    lbtn.Text = "Lý do thu hồi";
                }
                else if (trangThai == 3)
                {
                    lbTrangThai.Text = "Đã phát hành";
                    if (e.Item.Cells[5].Text == "1")
                    {
                        lbtn.Text = "VBĐH sửa";
                    }
                    else
                    {
                        lbtn.Text = "VBĐH đang sửa(Đóng)";
                    }
                }
                else if (trangThai == 4)
                {
                    lbTrangThai.Text = "Phát hành thành công";
                    lbtn.Text = "";
                }
                else if (trangThai == 5)
                {
                    lbTrangThai.Text = "Phát hành không thành công";
                    lbtn.Text = "Phát hành lại";
                }
                else if (trangThai == 6 && V_NGAYGUI != "")
                {
                    lbTrangThai.Text = "Đã Gửi";
                }
                else if (trangThai == 7 && V_NGAYGUI != "")
                {
                    lbTrangThai.Text = "đã gửi";
                }
                // VNPT - 01/12/2025 - Lê Bá Thọ 
                if (xacThuc == 1)
                {
                    lbVNeID.Text = "Đã Gửi";
                }
                else
                {
                    lbVNeID.Text = "Chưa gửi do đương sự chưa được làm sạch";
                }
                if (trangThai == 0)
                {
                    lbVNeID.Text = "Chưa Gửi";
                }
            }
        }

        private void Update_AKT_SOTHAM_BANAN_ANPHI(decimal DonID, decimal DuongSuID, DateTime? NgayNhan)
        {
            AKT_SOTHAM_BANAN ba = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                bool isNew = false;
                AKT_SOTHAM_BANAN_ANPHI ba_ap = dt.AKT_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU == DuongSuID).FirstOrDefault();
                if (ba_ap == null)
                {
                    isNew = true;
                    ba_ap = new AKT_SOTHAM_BANAN_ANPHI();
                }
                ba_ap.DONID = DonID;
                ba_ap.DUONGSU = DuongSuID;
                ba_ap.NGAYNHANAN = NgayNhan;
                if (isNew)
                {
                    dt.AKT_SOTHAM_BANAN_ANPHI.Add(ba_ap);
                }
                dt.SaveChanges();
            }
        }

        bool IsHideColumn = false;
        int check = 0;
        protected void dgTructiep_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DataGrid dataGrid = (DataGrid)sender;
            BL.GSTP.AKT.AKT_TONGDAT_BL _BL = new BL.GSTP.AKT.AKT_TONGDAT_BL();
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                CheckBox chkIsSend = (CheckBox)e.Item.FindControl("chkIsSend");
                //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEID
                CheckBox chkIsXACTHUC_DLDCQG = (CheckBox)e.Item.FindControl("chkIsXACTHUC_DLDCQG");
                DropDownList ddlHinhthucgui = (DropDownList)e.Item.FindControl("ddlHinhthuc");
                TextBox txtNgaygui = (TextBox)e.Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)e.Item.FindControl("txtNgayNhan");
                TextBox txtNgayPhatHanh = (TextBox)e.Item.FindControl("txtNgayPhatHanh");
                string vHINHTHUCGUI = e.Item.Cells[2].Text;
                Label lbTenTCTT = (Label)e.Item.FindControl("lbTenTCTT");
                Label lbDiaChi = (Label)e.Item.FindControl("lbDiaChi");
                //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEI
                chkIsXACTHUC_DLDCQG.Enabled = false;
                //vHINHTHUCGUI = ((DropDownList)e.Item.FindControl("ddlHinhthuc")).SelectedValue;
                string vNgaygui = rowView["NGAYGUI"].ToString();
                ddlHinhthucgui.SelectedValue = vHINHTHUCGUI;
                #region Delete_RemoveButton
                int preItem = e.Item.ItemIndex - 1;
                Button btn_remove = e.Item.FindControl("btn_remove") as Button;
                Button btn_insert = e.Item.FindControl("btn_insert") as Button;
                DropDownList ddlNoiNhan = e.Item.FindControl("ddlNoiNhan") as DropDownList;
                DropDownList ddlTCTT = e.Item.FindControl("ddlTCTT") as DropDownList;
                TextBox txtDiachi = e.Item.FindControl("txtDiachi") as TextBox;
                string tenDuongSu = e.Item.Cells[21].Text;
                decimal? ID;
                try
                {
                    ID = Convert.ToDecimal(e.Item.Cells[0].Text);
                }
                catch
                {
                    ID = null;
                }
                lbTenTCTT.Text = _BL.GetTenTCTT_ById(e.Item.Cells[1].Text + "");
                if (ID == null) // nếu là hàng theem 
                {
                    var lbTenDuongSu = e.Item.FindControl("lbTenDuongSu") as Label;
                    lbTenDuongSu.Visible = false;
                    btn_insert.Visible = true;
                    btn_remove.Visible = true;
                    ddlNoiNhan.Visible = true;
                    ddlTCTT.Visible = true;
                    txtDiachi.Visible = true;
                    string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                    decimal DONID = Convert.ToDecimal(current_id);
                    AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();

                    List<KeyValuePair<string, string>> lstTGTT = new List<KeyValuePair<string, string>>();
                    dt.AKT_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList()
                        .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.TENDUONGSU, "QUYENNVLQ1" + "," + x.ID)));
                    //if (oT.MAGIAIDOAN == 2)
                    //{
                    //    dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == DONID)
                    //       .ToList()
                    //       .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    //}
                    //else if (oT.MAGIAIDOAN == 3)
                    //{
                    //    dt.AKT_PHUCTHAM_THAMGIATOTUNG.Where(x => x.DONID == DONID)
                    //       .ToList()
                    //       .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    //}
                    //lstTGTT.Add(new KeyValuePair<string, string>("Nhập nơi nhận khác", "KHÁC"));
                    decimal tdId = -1;
                    try
                    {
                        tdId = Convert.ToDecimal(hddid.Value);
                    }
                    catch
                    {
                        tdId = -1;
                    }
                    var atddtisSENT = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == tdId).ToList();
                    if (atddtisSENT.Count > 0)
                    {
                        var tddt = atddtisSENT.Select(x => x.DUONGSUID).Where(x => x != null).ToList();
                        dt.AKT_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ && !tddt.Contains(x.ID)).ToList()
                        .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.TENDUONGSU, x.TUCACHTOTUNG_MA + "1" + "," + x.ID)));
                    }
                    ddlNoiNhan.DataSource = lstTGTT;
                    ddlNoiNhan.DataTextField = "Key";
                    ddlNoiNhan.DataValueField = "Value";
                    ddlNoiNhan.DataBind();
                    ddlNoiNhan.DataBind();
                    ddlNoiNhan.Items.Insert(0, new ListItem("--Chọn nơi nhận--", ""));
                    ddlNoiNhan.Items[0].Attributes["disabled"] = "disabled";
                    ddlNoiNhan.Items[0].Attributes["selected"] = "selected";

                    DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                    ddlTCTT.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
                    ddlTCTT.DataTextField = "TEN";
                    ddlTCTT.DataValueField = "MA";
                    ddlTCTT.Visible = true;
                    ddlTCTT.DataBind();
                    ddlTCTT.Items.Insert(0, new ListItem("--Tất cả--", "-1"));

                    lbTenTCTT.Visible = false;
                    lbDiaChi.Visible = false;
                    var txtNoiNhan = e.Item.FindControl("txtNoiNhan") as TextBox;
                    txtNoiNhan.Visible = true;
                    txtNoiNhan.Text = lbTenDuongSu.Text;
                    try
                    {
                        ddlTCTT.SelectedValue = e.Item.Cells[1].Text + "";
                    }
                    catch { }
                }
                else
                {
                    btn_insert.Visible = true;
                    btn_remove.Visible = false;
                    ddlNoiNhan.Visible = false;
                    ddlTCTT.Visible = false;
                }

                if (preItem >= 0)
                {
                    Button pre_btn_remove = dgTructiep.Items[preItem].FindControl("btn_remove") as Button;
                    Button pre_btn_insert = dgTructiep.Items[preItem].FindControl("btn_insert") as Button;
                    pre_btn_remove.Visible = false;
                    pre_btn_insert.Visible = false;
                }
                #endregion

                //thêm đoạn code Thiều: đẩy dữ liệu lên form khi mà sửa
                if (vHINHTHUCGUI == "2" || vHINHTHUCGUI == "1")
                {
                    IsHideColumn = false;
                    check = 1;
                }
                if (check == 0)
                {
                    IsHideColumn = true;
                }

                if (IsHideColumn && (Convert.ToInt32(string.IsNullOrEmpty(CountItem.Value) ? "0" : CountItem.Value) - 1) == (e.Item.ItemIndex))
                {
                    dataGrid.Columns[19].Visible = false;
                    dataGrid.Columns[20].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn && (Convert.ToInt32(string.IsNullOrEmpty(CountItem.Value) ? "0" : CountItem.Value) - 1) == (e.Item.ItemIndex))
                {
                    dataGrid.Columns[19].Visible = true;
                    dataGrid.Columns[20].Visible = true;
                    check = 0;
                    IsHideColumn = false;
                }

                Label lblQuocGia = (Label)e.Item.FindControl("lblQuocGia");
                Label lblNoidung = (Label)e.Item.FindControl("lblNoidung");
                Label lblCoquan = (Label)e.Item.FindControl("lblCoquan");
                DropDownList ddlQuocGiaUT = (DropDownList)e.Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)e.Item.FindControl("ddlketquauttp");
                TextBox txtCoquan = (TextBox)e.Item.FindControl("txtCoquan");
                TextBox txtNoidung = (TextBox)e.Item.FindControl("txtNoidung");
                var dataQuocGiaUT = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
                var dataketquauttp = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME("KETQUAUT");
                ddlQuocGiaUT.DataSource = dataQuocGiaUT;
                ddlQuocGiaUT.DataTextField = "TEN";
                ddlQuocGiaUT.DataValueField = "ID";
                ddlQuocGiaUT.DataBind();
                ddlQuocGiaUT.Items.Insert(0, new ListItem("--Chọn--", "0"));

                ddlketquauttp.DataSource = dataketquauttp;
                ddlketquauttp.DataTextField = "TEN";
                ddlketquauttp.DataValueField = "ID";
                ddlketquauttp.DataBind();
                ddlketquauttp.Items.Insert(0, new ListItem("--Chọn--", "0"));
                ddlketquauttp.ToolTip = e.Item.Cells[0].Text;
                if (chkIsSend.Checked)
                {
                    decimal Id = 0;
                    try
                    {
                        Id = Convert.ToDecimal(e.Item.Cells[7].Text);
                    }
                    catch { }
                    //kiểm tra 
                    var uttpDi = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == Id);
                    if (uttpDi != null)
                    {
                        if (uttpDi.NGAYCHUYENKQUTVETOACAPDUOI.HasValue)
                        {
                            ddlketquauttp.Visible = true;
                            txtNgayNhan.Visible = true;
                        }
                        else
                        {
                            ddlketquauttp.Enabled = false;
                            txtNgayNhan.Enabled = false;
                        }
                        ddlHinhthucgui.Visible = true;
                        ddlHinhthucgui.Enabled = false;
                        ddlQuocGiaUT.Enabled = false;
                        txtCoquan.Enabled = false;
                        txtNoidung.Enabled = false;
                        txtNgaygui.Enabled = false;
                    }
                    else
                    {
                        if (vHINHTHUCGUI != "2" && vHINHTHUCGUI != "1")
                        {
                            ddlQuocGiaUT.Visible = false;
                            ddlketquauttp.Visible = false;
                            txtCoquan.Visible = false;
                            txtNoidung.Visible = false;
                            txtNgayNhan.Enabled = false;
                            lblQuocGia.Visible = false;
                            lblNoidung.Visible = false;
                            lblCoquan.Visible = false;
                            ddlHinhthucgui.Visible = true;
                            ddlHinhthucgui.Enabled = true;
                            txtNgaygui.Enabled = false;
                        }
                        else
                        {
                            ddlHinhthucgui.Visible = true;
                            ddlHinhthucgui.Enabled = true;
                            ddlketquauttp.Enabled = false;
                            txtNgayNhan.Enabled = false;
                            txtNgaygui.Enabled = true;
                            ddlQuocGiaUT.Enabled = true;
                            txtCoquan.Enabled = true;
                            txtNoidung.Enabled = true;
                        }
                    }
                    ddlQuocGiaUT.SelectedValue = e.Item.Cells[3].Text;
                    ddlketquauttp.SelectedValue = e.Item.Cells[6].Text;

                    txtNoidung.Text = e.Item.Cells[5].Text.Replace("&nbsp;", "");
                    txtCoquan.Text = e.Item.Cells[4].Text.Replace("&nbsp;", "");
                }
                else
                {
                    ddlQuocGiaUT.Visible = false;
                    ddlketquauttp.Visible = false;
                    txtCoquan.Visible = false;
                    txtNoidung.Visible = false;
                    txtNgayNhan.Enabled = false;
                    lblQuocGia.Visible = false;
                    lblNoidung.Visible = false;
                    lblCoquan.Visible = false;
                }
                if (vHINHTHUCGUI == "5")
                {
                    txtNgaygui.Visible = true;
                    txtNgayNhan.Visible = true;
                    txtNgaygui.Enabled = false;
                    txtNgayNhan.Enabled = false;
                }
                else
                {
                    txtNgaygui.Visible = true;
                    txtNgayNhan.Visible = true;

                    if (vHINHTHUCGUI == "2")
                    {
                        chkIsSend.Enabled = true;
                        chkIsSend.CssClass = "opacity_1";
                    }
                    else if (vHINHTHUCGUI == "1")
                    {
                        decimal Id = Convert.ToDecimal(e.Item.Cells[7].Text);
                        //kiểm tra 
                        var uttpDi = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == Id);
                        if (uttpDi == null)
                        {
                            //cấp trên chưa làm gì được sửa
                            chkIsSend.Enabled = true;
                            chkIsSend.CssClass = "opacity_1";
                        }
                        else
                        {
                            chkIsSend.Enabled = false;
                            chkIsSend.CssClass = "opacity_0_2";
                        }
                    }
                }
                if (vHINHTHUCGUI == "2")
                {
                    //ddlHinhthucgui.Visible = true;
                    //ddlHinhthucgui.Enabled = true;
                    ddlQuocGiaUT.Visible = true;
                    ddlQuocGiaUT.Enabled = true;
                    txtCoquan.Enabled = true;
                    txtNoidung.Enabled = true;
                    txtNgaygui.Enabled = true;
                    txtCoquan.Visible = true;
                    txtNoidung.Visible = true;
                    txtNgaygui.Visible = true;
                    txtNgayNhan.Visible = true;
                    txtNgayNhan.Enabled = false;
                    ddlketquauttp.Enabled = true;
                    ddlketquauttp.Visible = true;
                }
                if (cb_uttp.Checked == true)
                {
                    //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEI
                    dgTructiep.Columns[19].Visible = true;
                    dgTructiep.Columns[20].Visible = true;
                }
                else
                {
                    //---------01/12/2025----  vnpt chỉnh lấy thêm cột checkVNEI
                    dgTructiep.Columns[19].Visible = false;
                    dgTructiep.Columns[20].Visible = false;
                }
                DropDownList ddlHinhthuc = (DropDownList)e.Item.FindControl("ddlHinhthuc");
                if (chkIsSend.Checked == true)
                {
                    ddlHinhthuc.Visible = true;
                }
                else
                {
                    txtNgayNhan.Enabled = false;
                    ddlHinhthuc.Visible = false;
                }

            }
        }

        protected void dgTructuyen_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                CheckBox chkIsSend = (CheckBox)e.Item.FindControl("chkIsSendTT");

                string vNgaygui = rowView["NGAYGUI"].ToString();
                if (vNgaygui.Trim() != null && vNgaygui != "")
                    chkIsSend.Enabled = false;
                else
                    chkIsSend.Enabled = true;
            }
        }

        protected void ddlQuocGiaUT_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlketquauttp_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                DropDownList ddlUTTP = (DropDownList)Item.FindControl("ddlUTTP");
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                Label lblQuocGia = (Label)Item.FindControl("lblQuocGia");
                Label lblNoidung = (Label)Item.FindControl("lblNoidung");
                Label lblCoquan = (Label)Item.FindControl("lblCoquan");

                string vHINHTHUCGUI = ddlUTTP.SelectedValue;
                //check hình thức gửi
                if (vHINHTHUCGUI == "2" || vHINHTHUCGUI == "1")
                {
                    IsHideColumn = false;
                    check = 1;
                }
                if (check == 0)
                {
                    IsHideColumn = true;
                }
                int count = dgTructiep.Items.Count;
                if (IsHideColumn && count == (Item.ItemIndex + 1))
                {
                    dgTructiep.Columns[18].Visible = false;
                    dgTructiep.Columns[19].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn && count == (Item.ItemIndex + 1))
                {
                    dgTructiep.Columns[18].Visible = true;
                    dgTructiep.Columns[19].Visible = true;
                    check = 0;
                    IsHideColumn = false;
                }

                if (vHINHTHUCGUI == "2" || vHINHTHUCGUI == "1")
                {
                    ddlQuocGiaUT.Visible = true;
                    ddlketquauttp.Visible = true;
                    ddlketquauttp.Enabled = false;
                    txtCoquan.Visible = true;
                    txtNoidung.Visible = true;
                    lblQuocGia.Visible = true;
                    lblNoidung.Visible = true;
                    lblCoquan.Visible = true;
                    txtNgaygui.Enabled = true;
                    txtNgayNhan.Enabled = false;
                }
                else
                {
                    ddlQuocGiaUT.Visible = false;
                    ddlketquauttp.Visible = false;
                    txtCoquan.Visible = false;
                    txtNoidung.Visible = false;
                    lblQuocGia.Visible = false;
                    lblNoidung.Visible = false;
                    lblCoquan.Visible = false;
                    txtNgaygui.Enabled = false;
                    txtNgayNhan.Enabled = false;
                }
                if (vHINHTHUCGUI == "2")
                {
                    txtNgayNhan.Enabled = false;
                    ddlketquauttp.Visible = true;
                    ddlketquauttp.Enabled = true;
                }
                if (ddl == ddlUTTP)
                {
                    txtNgayNhan.Text = "";
                    ddlketquauttp.SelectedIndex = 0;
                    txtNgaygui.Text = "";
                    txtCoquan.Text = "";
                    txtNoidung.Text = "";
                    ddlQuocGiaUT.SelectedIndex = 0;
                }
                if (vHINHTHUCGUI == "5")
                {
                    txtNgayNhan.Visible = true;
                    txtNgayNhan.Enabled = false;
                    txtNgayNhan.Text = "";
                }
            }
        }

        protected void txtNgaygui_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            TextBox txtNgaygui = (TextBox)sender;
            DateTime dateNow = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                CheckBox chkIsSendTT = (CheckBox)Item.FindControl("chkIsSend");
                if (chkIsSendTT.Checked)
                {
                    if (!string.IsNullOrEmpty(txtNgaygui.Text))
                    {
                        DateTime ngayGui;
                        bool isparse = DateTime.TryParse(txtNgaygui.Text, cul, DateTimeStyles.None, out ngayGui);
                        if (isparse)
                        {
                            if (ngayGui > dateNow)
                            {
                                lbthongbao.Text = "Ngày gửi không được lớn hơn ngày hiện tại";
                                lbThongBaoThuHoi.Text = "";
                                txtNgaygui.Text = "";
                            }
                        }
                    }
                }
            }
        }

        protected void ddlHinhthuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (DataGridItem item in dgTructiep.Items)
            {
                DropDownList ddlHinhthuc = (DropDownList)item.FindControl("ddlHinhthuc");
                TextBox txtNgaygui = (TextBox)item.FindControl("txtNgaygui");
                TextBox txtNgayphathanh = (TextBox)item.FindControl("txtNgayphathanh");
                TextBox txtNgayNhan = (TextBox)item.FindControl("txtNgayNhan");
                var value = ddlHinhthuc.SelectedValue;
                //if (value == "0" || value == "5")
                //{
                //    txtNgayphathanh.Enabled = true;
                //    txtNgayNhan.Enabled = true;
                //}
                //else if (value == "2" || value == "1")
                //{
                //    txtNgayphathanh.Enabled = false;
                //    txtNgayNhan.Enabled = false;
                //}
                txtNgayphathanh.Enabled = false;
                txtNgayNhan.Enabled = false;
            }
        }

        protected void ddlUTTP_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                DropDownList ddlUTTP = (DropDownList)Item.FindControl("ddlUTTP");
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                Label lblQuocGia = (Label)Item.FindControl("lblQuocGia");
                Label lblNoidung = (Label)Item.FindControl("lblNoidung");
                Label lblCoquan = (Label)Item.FindControl("lblCoquan");

                string vUTTP = ddlUTTP.SelectedValue;
                if (vUTTP == "2" || vUTTP == "1")
                {
                    IsHideColumn = false;
                    check = 1;
                }
                if (check == 0)
                {
                    IsHideColumn = true;
                }
                int count = dgTructiep.Items.Count;
                if (IsHideColumn && count == (Item.ItemIndex + 1))
                {
                    dgTructiep.Columns[18].Visible = false;
                    dgTructiep.Columns[19].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn && count == (Item.ItemIndex + 1))
                {
                    dgTructiep.Columns[18].Visible = true;
                    dgTructiep.Columns[19].Visible = true;
                    check = 0;
                    IsHideColumn = false;
                }
                if (vUTTP == "2" || vUTTP == "1")
                {
                    ddlQuocGiaUT.Visible = true;
                    ddlketquauttp.Visible = true;
                    ddlketquauttp.Enabled = false;
                    txtCoquan.Visible = true;
                    txtNoidung.Visible = true;
                    lblQuocGia.Visible = true;
                    lblNoidung.Visible = true;
                    lblCoquan.Visible = true;
                    txtNgaygui.Enabled = true;
                    txtNgayNhan.Enabled = false;
                }
                else
                {
                    ddlQuocGiaUT.Visible = false;
                    ddlketquauttp.Visible = false;
                    txtCoquan.Visible = false;
                    txtNoidung.Visible = false;
                    lblQuocGia.Visible = false;
                    lblNoidung.Visible = false;
                    lblCoquan.Visible = false;
                    txtNgaygui.Enabled = false;
                    txtNgayNhan.Enabled = false;
                }
                if (vUTTP == "2")
                {
                    txtNgayNhan.Enabled = false;
                    ddlketquauttp.Visible = true;
                    ddlketquauttp.Enabled = true;
                }
                if (ddl == ddlUTTP)
                {
                    txtNgayNhan.Text = "";
                    ddlketquauttp.SelectedIndex = 0;
                    txtNgaygui.Text = "";
                    txtCoquan.Text = "";
                    txtNoidung.Text = "";
                    ddlQuocGiaUT.SelectedIndex = 0;
                }
                if (vUTTP == "5")
                {
                    txtNgayNhan.Visible = true;
                    txtNgayNhan.Enabled = false;
                    txtNgayNhan.Text = "";
                }
            }
        }

        protected void Unnamed_CheckedChanged(object sender, EventArgs e)
        {
            if (cb_uttp.Checked == true)
            {
                dgTructiep.Columns[17].Visible = true;
                dgTructiep.Columns[18].Visible = true;
                dgTructiep.Columns[19].Visible = true;
            }
            else
            {
                dgTructiep.Columns[17].Visible = false;
                dgTructiep.Columns[18].Visible = false;
                dgTructiep.Columns[19].Visible = false;
            }
        }

        protected void btn_insert_Click(object sender, EventArgs e)
        {
            if (cmdLammoi.Visible == false)
            {
                trDuongsu.Visible = false;
                decimal BMID = 0, IS_TD_DUONGSU = 0, IS_TD_VKS = 0, IS_TD_NGUYENDON = 0;
                decimal ANPHI_ID = 0;
                decimal FILEID = -1;
                if (ddlBieumau.SelectedValue == "0")
                {
                    return;
                }
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal bieu_mau_id = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                ANPHI_ID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[1]);

                //---------21/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                AKT_FILE oF = new AKT_FILE();
                if (ddlBieumau.SelectedValue.Split('_').Length > 2)
                {
                    FILEID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[2]);
                    oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id && x.ID == FILEID).FirstOrDefault();
                }
                else
                {
                    oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id).FirstOrDefault();
                }
                if (oF != null) BMID = oF.BIEUMAUID + "" == "" ? 0 : (decimal)oF.BIEUMAUID;

                DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == bieu_mau_id).FirstOrDefault();
                if (oBM != null)
                {
                    IS_TD_VKS = oBM.IS_TD_VKS + "" == "" ? 0 : (decimal)oBM.IS_TD_VKS;
                    IS_TD_DUONGSU = oBM.IS_TD_DUONGSU + "" == "" ? 0 : (decimal)oBM.IS_TD_DUONGSU;
                    IS_TD_NGUYENDON = oBM.IS_TD_NGUYENDON + "" == "" ? 0 : (decimal)oBM.IS_TD_NGUYENDON;
                }

                AKT_DON_BL oBL = new AKT_DON_BL();
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable oDTDS = null;
                DataTable dataTable = new DataTable();
                if (hddIsTructuyen.Value == "1")
                {
                    trTructuyen.Visible = true;
                }
                if (IS_TD_DUONGSU == 1)
                {
                    if (oBM.MABM == "100-DS")
                    {
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 0, ANPHI_ID);
                    }
                    else
                    {
                        //---------01/12/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 0, FILEID);
                    }
                    trDuongsu.Visible = true;
                }
                else if (IS_TD_NGUYENDON == 1 && IS_TD_DUONGSU != 1)
                {
                    if (oBM.MABM == "100-DS")
                    {
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 1, ANPHI_ID);
                    }
                    else
                    {
                        //---------01/12/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 1,FILEID);
                    }
                    trDuongsu.Visible = true;
                }
                if (trDuongsu.Visible)
                {
                    if (hddIsTructuyen.Value == "1")
                    {
                        DataTable dtTructuyen = CreateTable();
                        DataTable dtTructiep = CreateTable();
                        string strarrOnline = "," + hddarrDuongsuTructuyen.Value + ",";
                        foreach (DataRow r in oDTDS.Rows)
                        {
                            string strDSID = r["ID"] + "";
                            if (strarrOnline.Contains("," + strDSID + ","))
                            {//Online
                                DataRow rOnline = dtTructuyen.NewRow();
                                rOnline["ID"] = r["ID"];
                                rOnline["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                                rOnline["TENDUONGSU"] = r["TENDUONGSU"];
                                rOnline["TRANGTHAI"] = r["TRANGTHAI"];
                                rOnline["NGAYGUI"] = r["NGAYGUI"];
                                rOnline["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                                rOnline["TENTCTT"] = r["TENTCTT"];

                                rOnline["ANPHI_ID"] = r["ANPHI_ID"];
                                rOnline["SOTHONGBAO"] = r["SOTHONGBAO"];
                                rOnline["MA_THONGBAO"] = r["MA_THONGBAO"];

                                //dtTructuyen.Rows.Add(rOnline);
                            }
                            else
                            {
                                DataRow rTructiep = dtTructiep.NewRow();
                                rTructiep["ID"] = r["ID"];
                                rTructiep["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                                rTructiep["TENDUONGSU"] = r["TENDUONGSU"];
                                rTructiep["TRANGTHAI"] = r["TRANGTHAI"];
                                rTructiep["NGAYGUI"] = r["NGAYGUI"];
                                rTructiep["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                                rTructiep["TENTCTT"] = r["TENTCTT"];
                                rTructiep["HINHTHUCGUI"] = r["HINHTHUCGUI"];
                                rTructiep["DIACHI"] = r["DIACHI"];
                                rTructiep["NGAYPHATHANH"] = r["NGAYPHATHANH"];
                                rTructiep["NOINHAN"] = r["NOINHAN"];
                                rTructiep["QUOCGIA"] = r["QUOCGIA"];
                                rTructiep["COQUAN"] = r["COQUAN"];
                                rTructiep["NOIDUNG"] = r["NOIDUNG"];
                                rTructiep["KETQUAUTTP"] = r["KETQUAUTTP"];
                                rTructiep["TONGDAT_DOITUONG"] = r["TONGDAT_DOITUONG"];

                                rTructiep["ANPHI_ID"] = r["ANPHI_ID"];
                                rTructiep["SOTHONGBAO"] = r["SOTHONGBAO"];
                                rTructiep["MA_THONGBAO"] = r["MA_THONGBAO"];

                                dtTructiep.Rows.Add(rTructiep);
                            }
                        }
                        dataTable = dtTructiep;
                        CountItem.Value = dtTructiep.Rows.Count.ToString();
                        //dgTructuyen.DataSource = dtTructuyen;
                    }
                    else
                    {
                        dataTable = oDTDS;
                        CountItem.Value = oDTDS.Rows.Count.ToString();
                    }
                }

                int dataCount = dataTable.Rows.Count;
                int targerCount = dgTructiep.Items.Count + 1;
                // vnpt 03/12/2025
                if (dataTable != null)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        Sothongbao.Value = row["SOTHONGBAO"].ToString();
                    }
                }
                for (int i = dataCount; i < targerCount; i++)
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataTable.Rows.Add(dataRow);
                }
                //Set ngày gửi là ngày hiện tại
                if (dataTable != null)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                        {
                            row["NGAYGUI"] = DateTime.Now;
                        }
                    }
                }
                dgTructiep.DataSource = dataTable;
                dgTructiep.DataBind();
                if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
                if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
            }
            else
            {
                decimal TongDatID = hddid.Value + "" == "" ? 0 : Convert.ToDecimal(hddid.Value);
                BL.GSTP.AKT.AKT_TONGDAT_BL TONGDATBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();

                decimal bieu_mau_id = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == bieu_mau_id).FirstOrDefault();

                DataTable nguoiNhans = null;
                if (oBM.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí  
                {
                    nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(TongDatID);
                }
                else
                {
                    nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(TongDatID);
                }
                
                nguoiNhans.Columns.Add("TUCACHTOTUNG_MA");
                nguoiNhans.Columns.Add("TONGDAT_DOITUONG");
                nguoiNhans.Columns.Add("TENDUONGSU");
                nguoiNhans.Columns.Add("TENTCTT");
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    string name = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(row["ID"]));
                    row["TONGDAT_DOITUONG"] = row["ID"];
                    row["ID"] = row["DUONGSUID"];
                    row["TUCACHTOTUNG_MA"] = row["MATUCACH"];
                    row["TENDUONGSU"] = name;
                    row["TENTCTT"] = row["MATUCACH"];
                }
                //if (FILEID > 0)
                //{
                //    lbtDownload.Visible = true;
                //    hddFile.Value = FILEID + "";
                //}
                //else
                //    lbtDownload.Visible = false;
                nguoiNhans = Sort(nguoiNhans);
                int dataCount = nguoiNhans.Rows.Count;
                int curCount = dgTructiep.Items.Count;
                int targerCount = dgTructiep.Items.Count + 1;
                if (nguoiNhans != null)
                {
                    foreach (DataRow row in nguoiNhans.Rows)
                    {
                        Sothongbao.Value = row["SOTHONGBAO"].ToString(); // vnpt 03/12/2025
                    }
                }
                if (curCount < dataCount)
                {
                    for (int i = curCount; i < dataCount; i++)
                    {
                        nguoiNhans.Rows.RemoveAt(nguoiNhans.Rows.Count - 1);
                    }
                    DataRow dataRow = nguoiNhans.NewRow();
                    nguoiNhans.Rows.Add(dataRow);
                }
                else
                {
                    for (int i = dataCount; i < targerCount; i++)
                    {
                        DataRow dataRow = nguoiNhans.NewRow();
                        nguoiNhans.Rows.Add(dataRow);
                    }
                }
                var fItem = dgTructiep.Items[0];
                bool isPHBS = !fItem.Enabled;
                nguoiNhans = Sort(nguoiNhans);
                //Set ngày gửi là ngày hiện tại
                if (nguoiNhans != null)
                {
                    foreach (DataRow row in nguoiNhans.Rows)
                    {
                        if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                        {
                            row["NGAYGUI"] = DateTime.Now;
                        }
                    }
                }
                dgTructiep.DataSource = nguoiNhans;
                dgTructiep.DataBind();
                if (isPHBS)
                {
                    for (int i = 0; i < dataCount; i++)
                    {
                        dgTructiep.Items[i].Enabled = false;
                    }
                }
                if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
                if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
            }
        }

        protected void btn_remove_Click(object sender, EventArgs e)
        {
            if (cmdLammoi.Visible == false)
            {
                trDuongsu.Visible = false;
                decimal BMID = 0, IS_TD_DUONGSU = 0, IS_TD_VKS = 0, IS_TD_NGUYENDON = 0;
                decimal ANPHI_ID = 0;
                decimal FILEID = -1;

                if (ddlBieumau.SelectedValue == "0")
                {
                    return;
                }
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                decimal bieu_mau_id = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                ANPHI_ID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[1]);
                //---------21/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                if (ddlBieumau.SelectedValue.Split('_').Length > 2)
                {
                    FILEID = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[2]);
                }
                //AKT_FILE oF = dt.AKT_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == bieu_mau_id).FirstOrDefault();
                //if (oF != null) BMID = oF.BIEUMAUID + "" == "" ? 0 : (decimal)oF.BIEUMAUID;
                DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == bieu_mau_id).FirstOrDefault();
                if (oBM != null)
                {
                    IS_TD_VKS = oBM.IS_TD_VKS + "" == "" ? 0 : (decimal)oBM.IS_TD_VKS;
                    IS_TD_DUONGSU = oBM.IS_TD_DUONGSU + "" == "" ? 0 : (decimal)oBM.IS_TD_DUONGSU;
                    IS_TD_NGUYENDON = oBM.IS_TD_NGUYENDON + "" == "" ? 0 : (decimal)oBM.IS_TD_NGUYENDON;
                }

                AKT_DON_BL oBL = new AKT_DON_BL();
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable oDTDS = null;
                DataTable dataTable = new DataTable();
                if (hddIsTructuyen.Value == "1")
                {
                    trTructuyen.Visible = true;
                }
                if (IS_TD_DUONGSU == 1)
                {
                    if (oBM.MABM == "100-DS")
                    {
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 0, ANPHI_ID);
                    }
                    else
                    {
                        //---------01/12/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 0, FILEID);
                    }
                    trDuongsu.Visible = true;
                }
                else if (IS_TD_NGUYENDON == 1 && IS_TD_DUONGSU != 1)
                {
                    if (oBM.MABM == "100-DS")
                    {
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_ANPHI_GETBY(DONID, TOAANID, BMID, 1, ANPHI_ID);
                    }
                    else
                    {
                        //---------01/12/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                        oDTDS = TONGDAT_BL.AKT_TONGDATDOITUONG_GETBYFILEID(DONID, TOAANID, BMID, 0, FILEID);
                    }
                    trDuongsu.Visible = true;
                }
                if (trDuongsu.Visible)
                {
                    if (hddIsTructuyen.Value == "1")
                    {
                        DataTable dtTructuyen = CreateTable();
                        DataTable dtTructiep = CreateTable();
                        string strarrOnline = "," + hddarrDuongsuTructuyen.Value + ",";
                        foreach (DataRow r in oDTDS.Rows)
                        {
                            string strDSID = r["ID"] + "";
                            if (strarrOnline.Contains("," + strDSID + ","))
                            {//Online
                                DataRow rOnline = dtTructuyen.NewRow();
                                rOnline["ID"] = r["ID"];
                                rOnline["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                                rOnline["TENDUONGSU"] = r["TENDUONGSU"];
                                rOnline["TRANGTHAI"] = r["TRANGTHAI"];
                                rOnline["NGAYGUI"] = r["NGAYGUI"];
                                rOnline["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                                rOnline["TENTCTT"] = r["TENTCTT"];

                                rOnline["ANPHI_ID"] = r["ANPHI_ID"];
                                rOnline["SOTHONGBAO"] = r["SOTHONGBAO"];
                                rOnline["MA_THONGBAO"] = r["MA_THONGBAO"];

                                //dtTructuyen.Rows.Add(rOnline);
                            }
                            else
                            {
                                DataRow rTructiep = dtTructiep.NewRow();
                                rTructiep["ID"] = r["ID"];
                                rTructiep["TUCACHTOTUNG_MA"] = r["TUCACHTOTUNG_MA"];
                                rTructiep["TENDUONGSU"] = r["TENDUONGSU"];
                                rTructiep["TRANGTHAI"] = r["TRANGTHAI"];
                                rTructiep["NGAYGUI"] = r["NGAYGUI"];
                                rTructiep["NGAYNHANTONGDAT"] = r["NGAYNHANTONGDAT"];
                                rTructiep["TENTCTT"] = r["TENTCTT"];
                                rTructiep["HINHTHUCGUI"] = r["HINHTHUCGUI"];
                                rTructiep["DIACHI"] = r["DIACHI"];
                                rTructiep["NGAYPHATHANH"] = r["NGAYPHATHANH"];
                                rTructiep["NOINHAN"] = r["NOINHAN"];
                                rTructiep["QUOCGIA"] = r["QUOCGIA"];
                                rTructiep["COQUAN"] = r["COQUAN"];
                                rTructiep["NOIDUNG"] = r["NOIDUNG"];
                                rTructiep["KETQUAUTTP"] = r["KETQUAUTTP"];
                                rTructiep["TONGDAT_DOITUONG"] = r["TONGDAT_DOITUONG"];

                                rTructiep["ANPHI_ID"] = r["ANPHI_ID"];
                                rTructiep["SOTHONGBAO"] = r["SOTHONGBAO"];
                                rTructiep["MA_THONGBAO"] = r["MA_THONGBAO"];

                                dtTructiep.Rows.Add(rTructiep);
                            }
                        }

                        dataTable = dtTructiep;
                        CountItem.Value = dtTructiep.Rows.Count.ToString();
                        //dgTructuyen.DataSource = dtTructuyen;
                    }
                    else
                    {
                        dataTable = oDTDS;
                        CountItem.Value = oDTDS.Rows.Count.ToString();
                    }
                }
                int dataCount = dataTable.Rows.Count;
                int targerCount = dgTructiep.Items.Count - 1;
                // vnpt 03/12/2025
                if (dataTable != null)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        Sothongbao.Value = row["SOTHONGBAO"].ToString();
                    }
                }
                for (int i = dataCount; i < targerCount; i++)
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataTable.Rows.Add(dataRow);
                }
                //Set ngày gửi là ngày hiện tại
                if (dataTable != null)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                        {
                            row["NGAYGUI"] = DateTime.Now;
                        }
                    }
                }
                dgTructiep.DataSource = dataTable;
                dgTructiep.DataBind();
                if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
                if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
            }
            else
            {
                decimal TongDatID = hddid.Value + "" == "" ? 0 : Convert.ToDecimal(hddid.Value);
                BL.GSTP.AKT.AKT_TONGDAT_BL TONGDATBL = new BL.GSTP.AKT.AKT_TONGDAT_BL();

                decimal bieu_mau_id = Convert.ToDecimal(ddlBieumau.SelectedValue.Split('_')[0]);
                DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == bieu_mau_id).FirstOrDefault();
                DataTable nguoiNhans = null;
                if (oBM.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí  
                {
                    nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_ANPHI_GETBYTONGDATID(TongDatID);
                }
                else
                {
                    nguoiNhans = TONGDATBL.AKT_TONGDATDOITUONG_GETBYTONGDATID(TongDatID);
                }

                nguoiNhans.Columns.Add("TUCACHTOTUNG_MA");
                nguoiNhans.Columns.Add("TONGDAT_DOITUONG");
                nguoiNhans.Columns.Add("TENDUONGSU");
                nguoiNhans.Columns.Add("TENTCTT");
                foreach (DataRow row in nguoiNhans.Rows)
                {
                    string name = TONGDATBL.AKT_TONGDATDOITUONG_GETTENDUONGSU(Convert.ToDecimal(row["ID"]));
                    row["TONGDAT_DOITUONG"] = row["ID"];
                    row["ID"] = row["DUONGSUID"];
                    row["TUCACHTOTUNG_MA"] = row["MATUCACH"];
                    row["TENDUONGSU"] = name;
                    row["TENTCTT"] = row["MATUCACH"];
                    // vnpt 03/12/2025
                    Sothongbao.Value = row["SOTHONGBAO"]?.ToString();
                }
                //if (FILEID > 0)
                //{
                //    lbtDownload.Visible = true;
                //    hddFile.Value = FILEID + "";
                //}
                //else
                //    lbtDownload.Visible = false;
                int dataCount = nguoiNhans.Rows.Count;
                int targerCount = dgTructiep.Items.Count;
                nguoiNhans = Sort(nguoiNhans);
                if (dataCount >= targerCount)
                {
                    for (int i = targerCount; i <= dataCount; i++)
                        nguoiNhans.Rows.RemoveAt(nguoiNhans.Rows.Count - 1);
                }
                else
                {
                    for (int i = dataCount; i < targerCount; i++)
                    {
                        DataRow dataRow = nguoiNhans.NewRow();
                        nguoiNhans.Rows.Add(dataRow);
                    }
                    nguoiNhans.Rows.RemoveAt(nguoiNhans.Rows.Count - 1);
                }
                bool isPHBS = !dgTructiep.Items[0].Enabled;
                nguoiNhans = Sort(nguoiNhans);
                //Set ngày gửi là ngày hiện tại
                if (nguoiNhans != null)
                {
                    foreach (DataRow row in nguoiNhans.Rows)
                    {
                        if (row["NGAYGUI"].ToString() == null || row["NGAYGUI"].ToString() == "")
                        {
                            row["NGAYGUI"] = DateTime.Now;
                        }
                    }
                }
                dgTructiep.DataSource = nguoiNhans;
                dgTructiep.DataBind();
                if (isPHBS)
                {
                    for (int i = 0; i < dataCount; i++)
                    {
                        dgTructiep.Items[i].Enabled = false;
                    }
                    (dgTructiep.Items[dataCount - 1].FindControl("btn_insert") as Button).Enabled = true;
                }
                if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
                if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
            }
        }

        protected void ddlNoiNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (DataGridItem item in dgTructiep.Items)
            {
                DropDownList ddlNoiNhan = item.FindControl("ddlNoiNhan") as DropDownList;
                DropDownList ddlTCTT = item.FindControl("ddlTCTT") as DropDownList;
                TextBox txtNoiNhan = item.FindControl("txtNoiNhan") as TextBox;
                TextBox txtDiachi = item.FindControl("txtDiachi") as TextBox;
                Label lbDiaChi = item.FindControl("lbDiaChi") as Label; // vnpt 03/12/2025
                CheckBox chkIsSend = item.FindControl("chkIsSend") as CheckBox;
                CheckBox chkIsXACTHUC_DLDCQG = item.FindControl("chkIsXACTHUC_DLDCQG") as CheckBox;
                // vnpt 03/12/2025
                Label lbSothongbao = item.FindControl("lbSothongbao") as Label;
                lbSothongbao.Text = Sothongbao.Value;

                chkIsXACTHUC_DLDCQG.Enabled = false;
                // vnpt 29/11/2025 chỉnh check nơi nhận, dttd
                if (ddlNoiNhan.Items.Count > 0)
                {
                    //ddlNoiNhan.Items[0].Attributes["disabled"] = "disabled";
                    if (ddlNoiNhan.SelectedValue == "KHÁC" || string.IsNullOrEmpty(ddlNoiNhan.SelectedValue))
                    {
                        // vnpt 29/11/2025 chỉnh check nơi nhận, dttd
                        chkIsSend.Checked = false;
                        chkIsSend.Enabled = false;
                    }
                    else
                    {
                        // vnpt 29/11/2025 chỉnh check nơi nhận, dttd
                        chkIsSend.Enabled = true;
                    }
                }
                if (ddlNoiNhan.SelectedValue == "KHÁC" || string.IsNullOrEmpty(ddlNoiNhan.SelectedValue))
                {
                    if (txtNoiNhan.Enabled == false)
                    {
                        txtNoiNhan.Text = string.Empty;
                    }
                    txtNoiNhan.Enabled = true;
                }
                else
                {
                    txtNoiNhan.Enabled = false;
                    try
                    {
                        txtNoiNhan.Text = ddlNoiNhan.SelectedItem.Text;

                        string[] strSplit = ddlNoiNhan.SelectedValue.Split(',');
                        string temp = strSplit[1];
                        decimal nguoiID = Convert.ToDecimal(temp);
                        // vnpt 03/12/2025
                        // AKT_DON_THAMGIATOTUNG tgtt = dt.AKT_DON_THAMGIATOTUNG.FirstOrDefault(x => x.ID == nguoiID);
                        AKT_DON_DUONGSU tgtt = dt.AKT_DON_DUONGSU.FirstOrDefault(x => x.ID == nguoiID);
                        if (tgtt != null)
                        {
                            string diaChi = "";
                            item.Cells[0].Text = tgtt.ID.ToString();
                            string tamTruChiTiet = tgtt.TAMTRUCHITIET + "";
                            string hkttChiTiet = tgtt.HKTTCHITIET + "";
                            string maTen = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == tgtt.TAMTRUID)?.MA_TEN ?? "" + "";

                            if (!string.IsNullOrWhiteSpace(tamTruChiTiet))
                            {
                                diaChi = tamTruChiTiet;

                                if (tgtt.TAMTRUID != null && tgtt.TAMTRUID != 0 && !string.IsNullOrWhiteSpace(maTen))
                                {
                                    diaChi += ", " + maTen;
                                }
                            }
                            else
                            {
                                diaChi = hkttChiTiet;
                                if (!string.IsNullOrWhiteSpace(hkttChiTiet))
                                {
                                    if (tgtt.TAMTRUID != null && tgtt.TAMTRUID != 0 && !string.IsNullOrWhiteSpace(maTen))
                                    {
                                        diaChi += ", " + maTen;
                                    }
                                }
                                else if (!string.IsNullOrWhiteSpace(maTen))
                                {
                                    diaChi = maTen;
                                }
                            }

                            txtDiachi.Text = diaChi;
                            lbDiaChi.Text = diaChi;
                            if (!string.IsNullOrWhiteSpace(diaChi))
                            {
                                txtDiachi.Visible = false;
                                lbDiaChi.Visible = true;
                            }
                            else
                            {
                                txtDiachi.Visible = true;
                                lbDiaChi.Visible = false;
                            }


                            chkIsXACTHUC_DLDCQG.Checked = tgtt.XACTHUC_DLDCQG == 1;
                        }
                    }
                    catch { }
                    // Chọn TCTT theo người trên ddl
                    try
                    {
                        string[] strSplit = ddlNoiNhan.SelectedValue.Split(',');
                        ddlTCTT.SelectedValue = ddlTCTT.Items.FindByValue(strSplit[0]).Value;
                    }
                    catch { }
                }
            }
        }

        protected void Unnamed_Click(object sender, EventArgs e)
        {
            BL.GSTP.AKT.AKT_TONGDAT_BL tONGDAT_BL = new BL.GSTP.AKT.AKT_TONGDAT_BL();

            int count = 0;
            bool isPhatHanh = true;
            bool isDaGui = false;
            decimal? TongDatID = null;
            foreach (DataGridItem item in dgList.Items)
            {
                var cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                decimal status = Convert.ToDecimal(item.Cells[4].Text);

                HiddenField Hi_column_value = (HiddenField)item.FindControl("Hi_column_value");
                String[] ND_id_arr = Hi_column_value.Value.Split(';');
                string V_NGAYGUI = ND_id_arr[0] + "";
                string V_NGAYPHATHANH = ND_id_arr[1] + "";

                if (cb_thuhoi.Checked == true)
                {
                    count++;
                    TongDatID = Convert.ToDecimal(item.Cells[1].Text);
                    if (count == 2)
                    {
                        break;
                    }
                }
                decimal curTongDatID = Convert.ToDecimal(item.Cells[1].Text);
                if (curTongDatID == TongDatID)
                {
                    if (status == 3 && status == 4 && status == 5)//10/01/2025
                    {
                        isPhatHanh = true;
                    }
                    else
                    {
                        isPhatHanh = false;
                    }
                    //if (status != 3 && status != 4 && status != 5)
                    //{
                    //    isPhatHanh = false;
                    //}
                    if (status == 1)//10/01/2025
                    {
                        isDaGui = true;
                    }
                    if ((status == 5 || status == 6) && V_NGAYPHATHANH == "")//10/01/2025
                    {
                        isDaGui = true;
                    }
                }
            }
            if (count == 0)
            {
                lbThongBaoThuHoi.Text = "Vui lòng chọn văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            if (count > 1)
            {
                lbThongBaoThuHoi.Text = "Chỉ được thu hồi một văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            if (isPhatHanh)
            {
                lbThongBaoThuHoi.Text = "Văn bản đã ban hành nên không thể thực hiện Thu hồi";
                lbthongbao.Text = "";
                return;
            }
            if (!isDaGui)
            {
                lbThongBaoThuHoi.Text = "Văn bản đã gửi đi mới có thể thực hiện Thu hồi";
                lbthongbao.Text = "";
                return;
            }
            if (string.IsNullOrEmpty(txbNgayThuHoi.Text) || string.IsNullOrEmpty(txtLyDoThuHoi.Text))
            {
                lbThongBaoThuHoi.Text = "Ngày thu hồi và lý do thu hồi không được để trống";
                lbthongbao.Text = "";
                return;
            }

            try
            {
                DateTime NgayThuHoi;
                try
                {
                    NgayThuHoi = (String.IsNullOrEmpty(txbNgayThuHoi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txbNgayThuHoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
                catch
                {
                    lbThongBaoThuHoi.Text = "Ngày thu hồi không hợp lý";
                    lbthongbao.Text = "";
                    return;
                }
                string LyDoThuHoi = txtLyDoThuHoi.Text;
                List<decimal> tongDatIds = new List<decimal>();
                string NguoiSua = "" + Session[ENUM_SESSION.SESSION_USERNAME];
                foreach (DataGridItem item in dgList.Items)
                {
                    var cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                    decimal v_id = Convert.ToDecimal(item.Cells[1].Text);
                    if (cb_thuhoi.Checked == true)
                    {
                        tongDatIds.Add(v_id);
                    }
                }

                // Call API
                string result = CallApiThuhoi("4", tongDatIds, LyDoThuHoi, NgayThuHoi, NguoiSua);
                JToken jObject = JToken.Parse(result);
                if ((string)jObject["status"] == "SUCCESS")
                {
                    lbThongBaoThuHoi.Text = "Thu hồi thành công !";

                    // Update thu hồi nếu call api thành công
                    foreach (DataGridItem item in dgList.Items)
                    {
                        var cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                        decimal v_id = Convert.ToDecimal(item.Cells[1].Text);
                        if (cb_thuhoi.Checked == true)
                        {
                            //AnhPN log
                            LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                            var data = DataExtensions.FindById<AKT_TONGDAT>(v_id);
                            var CONTENT_JSON_OLD = JsonConvert.SerializeObject(data, Formatting.Indented);
                            log.InsertLog("AKT_TONGDAT", v_id.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Thu hồi", LyDoThuHoi, "", CONTENT_JSON_OLD);

                            //AnhPN log
                            List<AKT_TONGDAT_DOITUONG> lst = dt.AKT_TONGDAT_DOITUONG.Where(x => x.TONGDATID == v_id).ToList();
                            CONTENT_JSON_OLD = JsonConvert.SerializeObject(lst.FirstOrDefault(), Formatting.Indented);
                            log.InsertLog("AKT_TONGDAT_DOITUONG", v_id.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Thu hồi", LyDoThuHoi, "", CONTENT_JSON_OLD);

                            tONGDAT_BL.AKT_TONGDAT_THUHOI(v_id, NgayThuHoi, LyDoThuHoi, NguoiSua);
                        }
                    }
                }
                else
                {
                    lbThongBaoThuHoi.Text = "Thu hồi thất bại !";
                }
            }
            catch (Exception)
            {
                lbThongBaoThuHoi.Text = "Gửi sang VBĐH thất bại do không thể gọi api !";
            }

            lbthongbao.Text = "";
            txbNgayThuHoi.Text = txtLyDoThuHoi.Text = "";
            dgList.DataBind();
            LoadGrid();
        }

        protected void btnXoa_Click(object sender, EventArgs e)
        {
            decimal? TongDatID = null;
            int cntCheckbox = 0;
            bool canDelete = false;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");

                HiddenField Hi_column_value = (HiddenField)item.FindControl("Hi_column_value");
                String[] ND_id_arr = Hi_column_value.Value.Split(';');
                string V_NGAYGUI = ND_id_arr[0] + "";
                string V_NGAYPHATHANH = ND_id_arr[1] + "";//14/01/2025

                if (cb_thuhoi.Checked == true)
                {
                    cntCheckbox++;
                    TongDatID = Convert.ToDecimal(item.Cells[1].Text);
                }
                decimal curTongDatID = Convert.ToDecimal(item.Cells[1].Text);
                if (curTongDatID == TongDatID)
                {
                    decimal TrangThai = Convert.ToDecimal(item.Cells[4].Text);
                    if (TrangThai == 0 || TrangThai == 2)
                    {
                        canDelete = true;
                    }
                    if ((TrangThai == 5 || TrangThai == 6) && V_NGAYPHATHANH == "")//10/01/2025
                    {
                        canDelete = true;
                    }
                }
            }
            if (cntCheckbox == 0)
            {
                lbThongBaoThuHoi.Text = "Vui lòng chọn văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else if (cntCheckbox > 1)
            {
                lbThongBaoThuHoi.Text = "Chỉ được chọn tối đa 1 văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else
            {
                if (!canDelete)
                {
                    lbThongBaoThuHoi.Text = "Trạng thái này không được xóa";
                    lbthongbao.Text = "";
                    return;
                }
                xoa(TongDatID.Value);
            }
        }

        protected void btnSua_Click(object sender, EventArgs e)
        {
            decimal? TongDatID = null;
            int cntCheckbox = 0;
            bool canEdit = false;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                HiddenField Hi_column_value = (HiddenField)item.FindControl("Hi_column_value");
                String[] ND_id_arr = Hi_column_value.Value.Split(';');
                string V_NGAYGUI = ND_id_arr[0] + "";
                string V_NGAYPHATHANH = ND_id_arr[1] + "";//14/01/2025
                if (cb_thuhoi.Checked == true)
                {
                    cntCheckbox++;
                    TongDatID = Convert.ToDecimal(item.Cells[1].Text);
                }
                decimal curTongDatID = Convert.ToDecimal(item.Cells[1].Text);
                if (curTongDatID == TongDatID)
                {
                    decimal TrangThai = Convert.ToDecimal(item.Cells[4].Text);
                    if (TrangThai == 0 || TrangThai == 2)
                    {
                        canEdit = true;
                    }
                    if ((TrangThai == 5 || TrangThai == 6) && V_NGAYPHATHANH == "")//10/01/2025
                    {
                        canEdit = true;
                    }
                }
            }
            if (cntCheckbox == 0)
            {
                lbThongBaoThuHoi.Text = "Vui lòng chọn văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else if (cntCheckbox > 1)
            {
                lbThongBaoThuHoi.Text = "Chỉ được chọn tối đa 1 văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else
            {
                if (!canEdit)
                {
                    lbThongBaoThuHoi.Text = "Không sửa được Văn bản đã chuyển phát hành.";
                    lbthongbao.Text = "";
                    return;
                }
                lbthongbao.Text = "";
                hddid.Value = TongDatID.Value.ToString() + "";
                loadSua(TongDatID.Value);
                CountItem.Value = dgTructiep.Items.Count.ToString();
            }
        }

        protected void PHBS_Click(object sender, EventArgs e)
        {
            decimal? TongDatID = null;
            int cntCheckbox = 0;
            decimal? TrangThai = null;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                if (cb_thuhoi.Checked == true)
                {
                    cntCheckbox++;
                    TongDatID = Convert.ToDecimal(item.Cells[1].Text);
                    TrangThai = Convert.ToDecimal(item.Cells[4].Text);
                }
            }
            if (cntCheckbox == 0)
            {
                lbThongBaoThuHoi.Text = "Vui lòng chọn văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else if (cntCheckbox > 1)
            {
                lbThongBaoThuHoi.Text = "Chỉ được chọn tối đa 1 văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else
            {
                lbThongBaoThuHoi.Text = "";
                hddid.Value = TongDatID.Value.ToString() + "";
                loadPhatHanhBoSung(TongDatID.Value);
                lbthongbao.Text = "Phát hành bổ sung";
            }
        }

        public List<TongDatDTO> GetAnKinhDoanhThuongMai(List<decimal> ids)
        {
            List<AKT_TONGDAT> aktTongDats = dt.AKT_TONGDAT.Where(x => ids.Contains(x.ID) && (x.TRANGTHAI >= 0 && x.TRANGTHAI <= 2)).ToList();
            HashSet<decimal?> idBieuMaus = new HashSet<decimal?>(aktTongDats.Select(x => x.BIEUMAUID).ToList());
            List<DM_BIEUMAU> allBieuMau = dt.DM_BIEUMAU.Where(x => idBieuMaus.Contains(x.ID)).ToList();
            Dictionary<decimal?, DM_BIEUMAU> mapBieuMau = new Dictionary<decimal?, DM_BIEUMAU>();
            // bo xung thong tin van ban di an DS, HC, PS, LD, HNGD, KDTM
            HashSet<decimal?> idAKT_DON = new HashSet<decimal?>(aktTongDats.Select(x => x.DONID).ToList());
            List<AKT_DON> allAKTDon = dt.AKT_DON.Where(x => idAKT_DON.Contains(x.ID)).ToList();
            Dictionary<decimal?, AKT_DON> mapAktDon = new Dictionary<decimal?, AKT_DON>();
            Dictionary<decimal?, List<AKT_DON_DUONGSU>> mapDuongSu = dt.AKT_DON_DUONGSU
                .Where(x => idAKT_DON.Contains(x.DONID))
                .GroupBy(x => x.DONID, x => x)
                .ToDictionary(x => x.Key, x => x.ToList());
            // bo xung thong tin van ban di
            foreach (AKT_DON aktDon in allAKTDon)
            {
                mapAktDon.Add(aktDon.ID, aktDon);
            }

            foreach (DM_BIEUMAU bieuMau in allBieuMau)
            {
                mapBieuMau.Add(bieuMau.ID, bieuMau);
            }
            HashSet<string> usernames = new HashSet<string>(aktTongDats.Where(x => x.NGUOITAO != null).ToList().Select(x => x.NGUOITAO).ToList());

            // danh sach can bo
            Dictionary<string, decimal?> mapUser = new Dictionary<string, decimal?>();
            string sql = "SELECT nsd.USERNAME, dc.ID, dc.HOTEN FROM GSCM.DM_CANBO dc " +
                "JOIN GSCM.QT_NGUOISUDUNG nsd ON dc.ID = nsd.CANBOID " +
                "WHERE nsd.USERNAME IN ";
            string conditions = "(";
            foreach (AKT_TONGDAT tongDat in aktTongDats)
            {
                if (tongDat.NGUOITAO != null)
                {
                    conditions += "'" + tongDat.NGUOITAO + "',";
                }
            }
            if (conditions.Count() != 1)
            {
                conditions = conditions.Remove(conditions.Count() - 1);
                conditions += ")";
                sql += conditions;

                DataTable table = Cls_Comon.GetTableToSQL(sql);

                for (int i = 0; i < table.Rows.Count; i++)
                {
                    string username = table.Rows[i]["USERNAME"].ToString();
                    decimal id = decimal.Parse(table.Rows[i]["ID"].ToString());
                    mapUser.Add(username, id);
                }
            }
            List<TongDatDTO> danhSachTongDat = aktTongDats.Select(x => ToDTO(x, mapBieuMau, mapUser, mapAktDon, mapDuongSu)).ToList();

            Dictionary<decimal?, TongDatDTO> mapTongDat = new Dictionary<decimal?, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AKT_TONGDAT_DOITUONG> allDoiTuongs = dt.AKT_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.TONGDATID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AKT_DON_DUONGSU> donDuongSu = dt.AKT_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AKT_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AKT_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID) && x.TRANGTHAI == 1).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();

                foreach (var item in doiTuong)
                {
                    item.Sothongbao = GetSoThongBao(dto.BieuMauId ?? 0, dto.DonId ?? 0, item.DuongSuId ?? 0);
                }

                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        public List<AKT_TONGDAT> GetAnKinhDoanhThuongMaiThuHoi(List<decimal> ids)
        {
            List<AKT_TONGDAT> aktTongDats = dt.AKT_TONGDAT.Where(x => ids.Contains(x.ID)).ToList();
            return aktTongDats;
        }

        private TongDatDTO ToDTO<T>(T model, Dictionary<decimal?, DM_BIEUMAU> mapBieuMau, Dictionary<string, decimal?> mapUser, Dictionary<decimal?, AKT_DON> mapAKT_DON, Dictionary<decimal?, List<AKT_DON_DUONGSU>> mapDuongSu)
        {
            if (model == null)
                return null;

            // mapping AKT
            if (model.GetType() == typeof(AKT_TONGDAT))
            {
                AKT_TONGDAT entity = model as AKT_TONGDAT;
                TongDatDTO dto = new TongDatDTO();
                dto.ID = entity.ID;
                dto.LoaiAnID = 4;
                dto.TongDatId = entity.ID;
                dto.DonId = entity.DONID;
                dto.BieuMauId = entity.BIEUMAUID;
                dto.ToaAnId = entity.TOAANID;
                dto.IsTdVks = entity.IS_TD_VKS;
                dto.NguoiSua = entity.NGUOISUA;
                dto.NgayTao = entity.NGAYTAO;
                dto.NguoiTao = entity.NGUOITAO;
                dto.BieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].TENBM;
                dto.MaBieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].MABM;
                dto.Mavuviec = dto.DonId == null ? null : mapAKT_DON[dto.DonId].MAVUVIEC;
                dto.Tenvuviec = dto.DonId == null ? null : mapAKT_DON[dto.DonId].TENVUVIEC;
                dto.Magiaidoan = dto.DonId == null ? null : mapAKT_DON[dto.DonId].MAGIAIDOAN;
                dto.qhpl = dto.DonId == null ? null : mapAKT_DON[dto.DonId].QUANHEPHAPLUAT_NAME;
                //dto.mapID = entity.MAPID;
                //dto.mapTable = entity.MAP_TABLE;

                if (dto.NguoiTao != null)
                {
                    decimal? idNguoiTao;
                    bool isExists = mapUser.TryGetValue(dto.NguoiTao, out idNguoiTao);
                    dto.NguoiTaoId = idNguoiTao;
                }

                if (dto.DonId != null)
                {
                    dto.biDon = mapDuongSu[dto.DonId]
                        .Where(x => 1 == x.ISDAIDIEN && ENUM_DANSU_TUCACHTOTUNG.BIDON == x.TUCACHTOTUNG_MA)
                        .Select(x => x.TENDUONGSU)
                        .FirstOrDefault();
                    dto.nguyenDon = mapDuongSu[dto.DonId]
                        .Where(x => 1 == x.ISDAIDIEN && ENUM_DANSU_TUCACHTOTUNG.NGUYENDON == x.TUCACHTOTUNG_MA)
                        .Select(x => x.TENDUONGSU)
                        .FirstOrDefault();
                }

                // bo xung AKT_DON_XULY
                DM_BIEUMAU dM_BIEUMAU = new DM_BIEUMAU();
                if (entity.BIEUMAUID + "" != "")
                {
                    dM_BIEUMAU = mapBieuMau[entity.BIEUMAUID];
                }

                if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "29-DS")
                {
                    List<AKT_DON_XULY> aKT_DON_XULies = dt.AKT_DON_XULY.Where(x => x.DONID == entity.DONID).ToList();
                    if (aKT_DON_XULies != null && aKT_DON_XULies.Any())
                    {
                        dto.Sothongbao = Convert.ToString(aKT_DON_XULies[0].SOTHONGBAO);
                        dto.Ngaythongbao = Convert.ToDateTime(aKT_DON_XULies[0].NGAYTHONGBAO);
                    }
                    // lay thong tin can bo
                    decimal? canboid = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == entity.DONID && x.MAVAITRO == "VTTP_GIAIQUYETDON").Select(x => x.CANBOID).Take(1).toNumber();
                    dto.Nguoiky = canboid;
                }
                else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí 
                {
                    AKT_ANPHI aDS_ANPHI = dt.AKT_ANPHI.Where(x => x.ID == entity.MAPID).FirstOrDefault();
                    DON_MIENANPHI_BL dON_MIENANPHI = new DON_MIENANPHI_BL();

                    DVCQG_THANH_TOAN_BL dVCQG_THANH_TOAN = new DVCQG_THANH_TOAN_BL();

                    if (aDS_ANPHI != null)
                    {
                        DataTable DON_MIENANPHI = dON_MIENANPHI.GET_DON_MIENANPHI_BY_ANPHI_ID(aDS_ANPHI.ID, 4);
                        dto.Sothongbao = DON_MIENANPHI.Rows.Count > 0 ? DON_MIENANPHI.Rows[0]["SOTHONGBAO"].ToString() + DON_MIENANPHI.Rows[0]["STB_PHU"] : aDS_ANPHI.SOTHONGBAO + aDS_ANPHI.STB_PHU;
                        dto.Ngaythongbao = DON_MIENANPHI.Rows.Count > 0 ? Convert.ToDateTime(DON_MIENANPHI.Rows[0]["NGAYTHONGBAO"]) : aDS_ANPHI.NGAYTHONGBAO;
                        //dto.mathongbao = dVCQG_THANH_TOAN.DVCQG_THANH_TOAN_SEARCH(2, entity.DONID.Value, aDS_ANPHI.ID, "4");
                    }

                }
                else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "30-DS")
                {
                    List<AKT_SOTHAM_THULY> aKT_DON_XULies = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == entity.DONID).ToList();
                    if (aKT_DON_XULies != null && aKT_DON_XULies.Any())
                    {
                        dto.Sothongbao = Convert.ToString(aKT_DON_XULies[0].SOTHONGBAO);
                        dto.Ngaythongbao = Convert.ToDateTime(aKT_DON_XULies[0].NGAYTHONGBAO);
                    }
                    // lay thong tin can bo
                    decimal? canboid = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == entity.DONID && x.MAVAITRO == "VTTP_GIAIQUYETDON").Select(x => x.CANBOID).Take(1).toNumber();
                    dto.Nguoiky = canboid;
                }
                else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "65-DS")
                {
                    List<AKT_PHUCTHAM_THULY> aKT_DON_XULies = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == entity.DONID).ToList();
                    if (aKT_DON_XULies != null && aKT_DON_XULies.Any())
                    {
                        dto.Sothongbao = Convert.ToString(aKT_DON_XULies[0].SOTHONGBAO);
                        dto.Ngaythongbao = Convert.ToDateTime(aKT_DON_XULies[0].NGAYTHONGBAO);
                        dto.Nguoiky = aKT_DON_XULies[0].NGUOIKYID;
                    }
                }
                else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "52-DS") // 52-DS. Bản án dân sự sơ thẩm vnpt Lê Bá Thọ 28/11/2025 lấy số cho vbdh
                {
                    AKT_SOTHAM_BANAN ba = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == entity.DONID).FirstOrDefault();
                    if (ba != null)
                    {
                        dto.Sothongbao = Convert.ToString(ba.SOBANAN);
                        dto.Ngaythongbao = Convert.ToDateTime(ba.NGAYTUYENAN);
                        //load người kí - mặc định chủ tọa
                        AKT_SOTHAM_HDXX oHD = dt.AKT_SOTHAM_HDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN && x.DONID == entity.DONID).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault();
                        if (oHD != null)
                        {
                            DM_CANBO oTPCT = dt.DM_CANBO.Where(x => x.ID == oHD.CANBOID).FirstOrDefault();
                            if (oTPCT != null)
                            {
                                dto.Nguoiky = oTPCT.ID;
                            }
                        }
                    }
                }
                else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "75-DS") // 75-DS. Bản án dân sự phúc thẩm vnpt Lê Bá Thọ 28/11/2025 lấy số cho vbdh
                {
                    AKT_PHUCTHAM_BANAN ba = dt.AKT_PHUCTHAM_BANAN.Where(x => x.DONID == entity.DONID).FirstOrDefault();
                    if (ba != null)
                    {
                        dto.Sothongbao = Convert.ToString(ba.SOBANAN);
                        dto.Ngaythongbao = Convert.ToDateTime(ba.NGAYTUYENAN);
                        //load người kí - mặc định chủ tọa
                        AKT_PHUCTHAM_HDXX oHD = dt.AKT_PHUCTHAM_HDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN && x.DONID == entity.DONID).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault();
                        if (oHD != null)
                        {
                            DM_CANBO oTPCT = dt.DM_CANBO.Where(x => x.ID == oHD.CANBOID).FirstOrDefault();
                            if (oTPCT != null)
                            {
                                dto.Nguoiky = oTPCT.ID;
                            }
                        }
                    }
                }
                else
                {
                    List<AKT_FILE> aKT_FILEs = dt.AKT_FILE.Where(x => x.ID == entity.FILEID).ToList();
                    if (aKT_FILEs != null && aKT_FILEs.Any())
                    {
                        decimal? maGiaiDoan = aKT_FILEs[0].MAGIAIDOAN;
                        // so tham
                        if (maGiaiDoan != null && maGiaiDoan == 2)
                        {
                            List<AKT_SOTHAM_QUYETDINH> aKT_SOTHAM_QUYETDINHs = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.DONID == entity.DONID).ToList();
                            if (aKT_SOTHAM_QUYETDINHs != null && aKT_SOTHAM_QUYETDINHs.Any())
                            {
                                dto.Sothongbao = Convert.ToString(aKT_SOTHAM_QUYETDINHs[0].SOQD);
                                dto.Ngaythongbao = Convert.ToDateTime(aKT_SOTHAM_QUYETDINHs[0].NGAYQD);
                                dto.Nguoiky = Convert.ToDecimal(aKT_SOTHAM_QUYETDINHs[0].NGUOIKYID);
                            }
                        }
                        // phuc tham
                        else if (maGiaiDoan != null && maGiaiDoan == 3)
                        {
                            List<AKT_PHUCTHAM_QUYETDINH> aKT_PHUCTHAM_QUYETDINHs = dt.AKT_PHUCTHAM_QUYETDINH.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.DONID == entity.DONID).ToList();
                            if (aKT_PHUCTHAM_QUYETDINHs != null && aKT_PHUCTHAM_QUYETDINHs.Any())
                            {
                                dto.Sothongbao = Convert.ToString(aKT_PHUCTHAM_QUYETDINHs[0].SOQD);
                                dto.Ngaythongbao = Convert.ToDateTime(aKT_PHUCTHAM_QUYETDINHs[0].NGAYQD);
                                dto.Nguoiky = Convert.ToDecimal(aKT_PHUCTHAM_QUYETDINHs[0].NGUOIKYID);
                            }
                        }
                    }
                }
                return dto;
            }
            return null;
        }

        private DoiTuongDTO ToDTO<T, E>(TongDatDTO entityTongDat, T model, E duongSuModel)
        {
            if (model == null) return null;

            // mapping án hình sự
            if (model.GetType() == typeof(AHS_TONGDAT_DOITUONG))
            {
                AHS_TONGDAT_DOITUONG entity = model as AHS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.QuocGia = entity.QUOCGIA;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    AHS_BICANBICAO biCao = duongSuModel as AHS_BICANBICAO;
                    dto.TenDuongSu = biCao.HOTEN;
                    dto.SoCMND = biCao.SOCMND;
                    dto.QuocTichId = biCao.QUOCTICHID;
                    dto.TinhId = biCao.TAMTRU ?? biCao.HKTT;
                    dto.HuyenId = biCao.TAMTRU_HUYEN ?? biCao.HKTT_HUYEN;
                    dto.DiaChiChiTiet = biCao.TAMTRUCHITIET ?? biCao.KHTTCHITIET;
                    dto.NamSinh = biCao.NAMSINH;
                }
                return dto;
            }

            // mapping án dân sự
            if (model.GetType() == typeof(ADS_TONGDAT_DOITUONG))
            {
                ADS_TONGDAT_DOITUONG entity = model as ADS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.QuocGia = entity.QUOCGIA;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    ADS_DON_DUONGSU duongSu = duongSuModel as ADS_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            // mapping án hôn nhân và gia đình
            if (model.GetType() == typeof(AHN_TONGDAT_DOITUONG))
            {
                AHN_TONGDAT_DOITUONG entity = model as AHN_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    AHN_DON_DUONGSU duongSu = duongSuModel as AHN_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            // mapping án KDTM
            if (model.GetType() == typeof(AKT_TONGDAT_DOITUONG))
            {
                AKT_TONGDAT_DOITUONG entity = model as AKT_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    AKT_DON_DUONGSU duongSu = duongSuModel as AKT_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            // mapping án lao động
            if (model.GetType() == typeof(ALD_TONGDAT_DOITUONG))
            {
                ALD_TONGDAT_DOITUONG entity = model as ALD_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    ALD_DON_DUONGSU duongSu = duongSuModel as ALD_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            // mapping án hành chính
            if (model.GetType() == typeof(AHC_TONGDAT_DOITUONG))
            {
                AHC_TONGDAT_DOITUONG entity = model as AHC_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    AHC_DON_DUONGSU duongSu = duongSuModel as AHC_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            // mapping án phá sản
            if (model.GetType() == typeof(APS_TONGDAT_DOITUONG))
            {
                APS_TONGDAT_DOITUONG entity = model as APS_TONGDAT_DOITUONG;
                DoiTuongDTO dto = new DoiTuongDTO();
                dto.MaTuCach = entity.MATUCACH;
                dto.HinhThucGui = entity.HINHTHUCGUI;
                dto.DuongSuId = entity.DUONGSUID;
				dto.DoiTuongId = entity.ID;
                dto.CoQuan = entity.COQUAN;
                dto.NoiDung = entity.NOIDUNG;
                dto.NguoiTao = entityTongDat.NguoiTao;
                dto.NgayTao = entityTongDat.NgayTao;
                dto.NguoiSua = entityTongDat.NguoiSua;
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;

                if (duongSuModel != null)
                {
                    APS_DON_DUONGSU duongSu = duongSuModel as APS_DON_DUONGSU;
                    dto.TenDuongSu = duongSu.TENDUONGSU;
                    dto.SoCMND = duongSu.SOCMND;
                    dto.QuocTichId = duongSu.QUOCTICHID;
                    dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                    dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                    dto.DiaChiChiTiet = duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET;
                    dto.NamSinh = duongSu.NAMSINH;
                    dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
                }
                return dto;
            }

            return null;
        }

        protected string CallApi(List<decimal> ids)
        {
            WebClient client = new WebClient();
            // string apiUrl = "http://10.1.82.69:8082/rest/dataMigration/tong-dat" ;
            string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tong-dat";
            var input = GetAnKinhDoanhThuongMai(ids);
            string inputJson = JsonConvert.SerializeObject(input);
            client.Headers.Clear();
            client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
            client.Encoding = Encoding.UTF8;
            string contents = client.UploadString(apiUrl, inputJson);
            return contents;
        }

        protected string CallApiThuhoi(string vLoaiAnID, List<decimal> ids, string LyDoThuHoi, DateTime NgayThuHoi, string NguoiSua)
        {
            WebClient client = new WebClient();
            string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tong-dat-thu-hoi";
            //var input = GetAnLaoDongThuHoi(ids);

            var input = new
            {
                loaiAnID = vLoaiAnID,
                reallocateReason = LyDoThuHoi,
                reallocateUser = NguoiSua,
                reallocateDate = NgayThuHoi,
                allocatedList = ids
            };
            string inputJson = JsonConvert.SerializeObject(input);
            client.Headers.Clear();
            client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
            client.Encoding = Encoding.UTF8;
            string contents = client.UploadString(apiUrl, inputJson);
            return contents;
        }

        protected void VBDH_Click(object sender, EventArgs e)
        {
            decimal? TongDatID = null;
            int cntCheckbox = 0;
            decimal? TrangThai = null;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox cb_thuhoi = (CheckBox)item.FindControl("cb_thuhoi");
                if (cb_thuhoi.Checked == true)
                {
                    cntCheckbox++;
                    TongDatID = Convert.ToDecimal(item.Cells[1].Text);
                    TrangThai = Convert.ToDecimal(item.Cells[4].Text);
                    if (TrangThai == 2)
                    {
                        break;
                    }
                }
            }
            if (TrangThai == 2)
            {
                lbThongBaoThuHoi.Text = "Trạng thái thu hồi không thể gửi VBĐH";
                lbthongbao.Text = "";
                return;
            }
            if (cntCheckbox == 0)
            {
                lbThongBaoThuHoi.Text = "Vui lòng chọn văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else if (cntCheckbox > 1)
            {
                lbThongBaoThuHoi.Text = "Chỉ được chọn tối đa 1 văn bản tống đạt";
                lbthongbao.Text = "";
                return;
            }
            else
            {
                try
                {
                    List<decimal> lst = new List<decimal>();
                    lst.Add(TongDatID.Value);

                    string status = CallApi(lst);

                    if (status == "SUCCESS")
                    {
                        lbThongBaoThuHoi.Text = "Gửi thành công !";

                        //AnhPN log
                        LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                        log.InsertLog("CallApi_AKT", TongDatID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Gửi sang VBĐH", "Gửi thành công", "", "");
                    }
                    else
                    {
                        lbThongBaoThuHoi.Text = "Gửi thất bại !";

                        //AnhPN log
                        LOG_TONGDAT_QLTA log = new LOG_TONGDAT_QLTA();
                        log.InsertLog("CallApi_AKT", TongDatID.ToString(), Session[ENUM_SESSION.SESSION_USERNAME].ToString(), "Gửi sang VBĐH", "Gửi thất bại", "", "");
                    }
                }
                catch (Exception)
                {
                    lbThongBaoThuHoi.Text = "Gửi sang VBĐH thất bại do không thể gọi api !";
                }
            }
            lbthongbao.Text = "";
        }

        protected void ddlTCTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (DataGridItem item in dgTructiep.Items)
            {
                DropDownList ddlNoiNhan = item.FindControl("ddlNoiNhan") as DropDownList;
                DropDownList ddlTCTT = item.FindControl("ddlTCTT") as DropDownList;
                TextBox txtNoiNhan = item.FindControl("txtNoiNhan") as TextBox;
                txtNoiNhan.Enabled = true;

                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                List<KeyValuePair<string, string>> lstTGTT = new List<KeyValuePair<string, string>>();
                if (oT.MAGIAIDOAN == 2)
                {
                    if (ddlTCTT.SelectedValue == "-1")
                    {
                        dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == DONID)
                                                .ToList()
                                                .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    }
                    else
                    {
                        dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == DONID && x.TUCACHTGTTID == ddlTCTT.SelectedValue)
                                                .ToList()
                                                .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    }
                }
                else if (oT.MAGIAIDOAN == 3)
                {
                    if (ddlTCTT.SelectedValue == "-1")
                    {
                        dt.AKT_PHUCTHAM_THAMGIATOTUNG.Where(x => x.DONID == DONID)
                                                    .ToList()
                                                    .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    }
                    else
                    {
                        dt.AKT_PHUCTHAM_THAMGIATOTUNG.Where(x => x.DONID == DONID && x.TUCACHTGTTID == ddlTCTT.SelectedValue)
                                                    .ToList()
                                                    .ForEach(x => lstTGTT.Add(new KeyValuePair<string, string>(x.HOTEN, x.TUCACHTGTTID + "," + x.ID)));
                    }
                }
                lstTGTT.Add(new KeyValuePair<string, string>("Nhập nơi nhận khác", "KHÁC"));
                ddlNoiNhan.DataSource = lstTGTT;
                ddlNoiNhan.DataTextField = "Key";
                ddlNoiNhan.DataValueField = "Value";
                ddlNoiNhan.SelectedValue = "KHÁC";
                ddlNoiNhan.DataBind();
            }
        }

        private string GetSoThongBao(decimal bieuMauID, decimal donID, decimal duongsuID)
        {
            string STB = "";
            decimal bmID = bieuMauID;
            DM_BIEUMAU bieu_mau = dt.DM_BIEUMAU.Where(x => x.ID == bmID).FirstOrDefault();

            if (bmID == 67) // 29-DS. Thông báo tạm ứng án phí
            {
                AKT_ANPHI anPhi = dt.AKT_ANPHI.Where(x => x.DONID == donID && x.DUONGSU_ID == duongsuID).FirstOrDefault();
                if (anPhi != null)
                {
                    STB = anPhi.SOTHONGBAO;
                }
            }
            else if (bieu_mau.MABM == "100-DS") // 100-DS. Thông báo về việc miễn tạm ứng án phí 
            {
                AKT_ANPHI anPhi = dt.AKT_ANPHI.Where(x => x.DONID == donID && x.DUONGSU_ID == duongsuID).FirstOrDefault();
                DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();

                DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(anPhi.ID, 4);
                if (anPhi != null)
                {
                    if (dataTable.Rows.Count > 0)
                    {
                        STB = dataTable.Rows[0]["SOTHONGBAO"] + "";
                    }
                    else
                    {
                        STB = anPhi.SOTHONGBAO;
                    }

                }
            }
            else if (bmID == 68) // 30-DS. Thông báo về việc thụ lý vụ án
            {
                AKT_SOTHAM_THULY thuly = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == donID).FirstOrDefault();
                if (thuly != null)
                {
                    STB = thuly.SOTHONGBAO;
                }
            }
            else if (bmID == 230) // 52-DS. Bản án dân sự sơ thẩm
            {
                AKT_SOTHAM_BANAN ba = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == donID).FirstOrDefault();
                if (ba != null)
                {
                    STB = ba.SOBANAN;
                }
            }
            else if (bmID == 550) // 75-DS. Bản án dân sự phúc thẩm vnpt Lê Bá Thọ 28/11/2025 lấy cho vbdh
            {
                AKT_PHUCTHAM_BANAN ba = dt.AKT_PHUCTHAM_BANAN.Where(x => x.DONID == donID).FirstOrDefault();
                if (ba != null)
                {
                    STB = ba.SOBANAN;
                }
            }
            else if (bieu_mau.QUYETDINHID != null) // Các biểu mẫu quyết định vụ việc
            {
                if (bieu_mau.GIAIDOAN == "2")
                {
                    AKT_SOTHAM_QUYETDINH qdinh = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.DONID == donID).FirstOrDefault();
                    if (qdinh != null)
                    {
                        STB = qdinh.SOQD;
                    }
                }
                else if (bieu_mau.GIAIDOAN == "3")
                {
                    AKT_PHUCTHAM_QUYETDINH qdinh = dt.AKT_PHUCTHAM_QUYETDINH.Where(x => x.DONID == donID).FirstOrDefault();
                    if (qdinh != null)
                    {
                        STB = qdinh.SOQD;
                    }
                }
            }

            return STB;
        }
    }
}