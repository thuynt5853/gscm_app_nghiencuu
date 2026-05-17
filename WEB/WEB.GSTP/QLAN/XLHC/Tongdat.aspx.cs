using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using DAL.DKK;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.TP_THADS;
using NLog;

namespace WEB.GSTP.QLAN.XLHC
{
    public partial class Tongdat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        DKKContextContainer dkk = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
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
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "", TOAANID = "0";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id), HinhThucNHanDon = 0, MAGIAIDOAN = 0;
                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                        List<XLHC_DUONGSU> lstDSTT = dt.XLHC_DUONGSU.Where(x => x.DONID == ID).ToList();
                        if (lstDSTT.Count > 0)
                            hddarrDuongsuTructuyen.Value = lstDSTT[0].ID.ToString();
                    }
                    List<DONKK_USER_DKNHANVB> lstDKVB = dkk.DONKK_USER_DKNHANVB.Where(x => x.VUVIECID == ID && x.MALOAIVUVIEC == ENUM_LOAIAN.BPXLHC && x.TRANGTHAI == 1).ToList();
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
                        //// Thu ky khong tong dat manhnd 26/08/2021
                        hddIsTructuyen.Value = "1";
                        //    trFile.Visible = true;
                    }
                    else
                    {
                        trFile.Visible = false;
                        hddIsTructuyen.Value = "0";
                    }
                    if (MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && TOAANID == (Session[ENUM_SESSION.SESSION_DONVIID] + ""))
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    cmdLammoi.Visible = false;
                }
            }
            catch (Exception ex) 
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }
        private void LoadCombobox()
        {
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id), MAGIAIDOAN = 0;
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                MAGIAIDOAN = oT.MAGIAIDOAN + "" == "" ? 0 : (decimal)oT.MAGIAIDOAN;
            }
            DM_BIEUMAU_BL oBL = new DM_BIEUMAU_BL();
            ddlBieumau.DataSource = oBL.DM_BIEUMAU_GETBY(8, 1, MAGIAIDOAN);
            ddlBieumau.DataTextField = "arrTEN";
            ddlBieumau.DataValueField = "ID";
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
                return false;
            }
            #region "Manhnd 05/08/2021 bo vi Thu ky khong tong dat chi xac dinh doi tuong se tong dat"
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

                    #region thiều
                    DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                    DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                    DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                    TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                    #endregion
                    if (chkIsSend.Checked)
                    {
                        IsChonDuongSu = true;
                        #region thiều
                        if (string.IsNullOrEmpty(txtNgaygui.Text) && (ddlHinhthucgui.SelectedValue == "3" || ddlHinhthucgui.SelectedValue == "4"))
                        {
                            lbthongbao.Text = "Vui lòng nhập ngày gửi";
                            return false;
                        }
                        if (ddlHinhthucgui.SelectedValue == "4")
                        {
                            if (ddlQuocGiaUT.SelectedValue == "0")
                            {
                                lbthongbao.Text = "Vui lòng nhập quốc gia";
                                return false;
                            }
                            if (string.IsNullOrEmpty(txtCoquan.Text))
                            {
                                lbthongbao.Text = "Vui lòng nhập cơ quuan";
                                return false;
                            }
                        }
                        #endregion
                        #region "Manhnd bo 04/08/2021 do Van thu se thong dat"
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
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal BMID = Convert.ToDecimal(ddlBieumau.SelectedValue);
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal ID = Convert.ToDecimal(hddid.Value);
                bool isNew = false;
                XLHC_TONGDAT oND = dt.XLHC_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                if (oND == null)
                {
                    oND = new XLHC_TONGDAT();
                    oND.TRANGTHAI = 0;// Chưa đăng lên Cổng thông tin điện tử
                    isNew = true;
                    oND.BIEUMAUID = BMID;
                }
                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                
                if (trVKS.Visible)
                {
                    oND.IS_TD_VKS = Convert.ToDecimal(rdbIsVKS.SelectedValue);
                    if (txtVKS_Ngaygui.Visible)
                        oND.IS_TD_VKS_NGAY = txtVKS_Ngaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_Ngaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (txtVKS_NgayNhan.Visible)
                        oND.NGAYNHANTONGDAT = txtVKS_NgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(this.txtVKS_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = "";
                        if (chkKySo.Checked)
                        {
                            string[] arr = hddFilePath.Value.Split('/');
                            strFilePath = arr[arr.Length - 1];
                            strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                        }
                        else
                            strFilePath = hddFilePath.Value.Replace("/", "\\");

                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                            dt.SaveChanges();
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                }
                if (isNew)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_TONGDAT.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                //Lưu thông tin tống đạt tới đương sự trực tiếp
                if (trDuongsu.Visible)
                {
                    decimal TongdatID = oND.ID;
                    foreach (DataGridItem Item in dgTructiep.Items)
                    {
                        CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                        TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                        TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");

                        DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                        #region Thiều 
                        DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                        DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                        TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                        TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                        #endregion
                        decimal vHinhthucgui = Convert.ToDecimal(ddlHinhthucgui.SelectedValue);
                        decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                        List<XLHC_TONGDAT_DOITUONG> lstCheck = dt.XLHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).ToList();
                        XLHC_TONGDAT_DOITUONG oTD = null;
                        if (lstCheck.Count > 0)
                        {
                            oTD = lstCheck[0];
                        }
                        else
                        {
                            oTD = new XLHC_TONGDAT_DOITUONG();
                        }
                        oTD.TONGDATID = TongdatID;
                        oTD.DUONGSUID = DuongsuID;
                        oTD.MATUCACH = Item.Cells[1].Text.Replace("&nbsp;", "");
                        oTD.HINHTHUCGUI = vHinhthucgui;

                        if (chkIsSend.Checked)
                        {
                            oTD.TRANGTHAI = 1;
                            #region Manhnd 04/08/2021 Văn thu se thong dat nen Thu ky chi xac dinh xem se tong dat cho ai
                            // chi lưu ngày nhận/niêm yết khi hình thức tống đạt là niêm yết
                            if (vHinhthucgui == 5)
                            {
                                //oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }

                            // Nếu văn bản tống đạt là bản án sơ thẩm thì sẽ lưu ADS_SOTHAM_BANAN_ANPHI
                            //if (ddlBieumau.SelectedItem.Text.ToLower().Contains("52-ds") || ddlBieumau.SelectedItem.Text.ToLower().Contains("bản án dân sự sơ thẩm") || lstTenBM.Text.ToLower().Contains("bản án dân sự sơ thẩm"))
                            //{
                            //    Update_ADS_SOTHAM_BANAN_ANPHI(DONID, DuongsuID, oTD.NGAYNHANTONGDAT);
                            //}
                            //}
                            //else
                            //{
                            //    oTD.NGAYGUI = (DateTime?)null;
                            //    oTD.NGAYNHANTONGDAT = (DateTime?)null;
                            //    oTD.TRANGTHAI = 0;
                            #endregion

                            #region Thiều 
                            oTD.NGAYGUI = txtNgaygui.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                            if (vHinhthucgui == 3 || vHinhthucgui == 4)
                            {
                                oTD.NGAYNHANTONGDAT = txtNgayNhan.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                oTD.QUOCGIA = Convert.ToDecimal(ddlQuocGiaUT.SelectedValue);
                                oTD.COQUAN = txtCoquan.Text;
                                oTD.NOIDUNG = txtNoidung.Text;
                                oTD.KETQUAUTTP = Convert.ToDecimal(ddlketquauttp.SelectedValue);
                            }
                            else
                            {
                                oTD.NGAYNHANTONGDAT = (DateTime?)null;
                                oTD.QUOCGIA = 0;
                                oTD.COQUAN = "";
                                oTD.NOIDUNG = "";
                                oTD.KETQUAUTTP = 0;
                            }
                            #endregion
                            if (lstCheck.Count == 0)
                                dt.XLHC_TONGDAT_DOITUONG.Add(oTD);
                            dt.SaveChanges();
                        }
                    }

                }
                //Lưu thông tin tống đạt tới đương sự trực tuyến
                if (trTructuyen.Visible)
                {
                    decimal TongdatID = oND.ID;
                    foreach (DataGridItem Item in dgTructuyen.Items)
                    {
                        decimal DuongsuID = Convert.ToDecimal(Item.Cells[0].Text);
                        List<XLHC_TONGDAT_DOITUONG> lstCheck = dt.XLHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == TongdatID && x.DUONGSUID == DuongsuID).ToList();
                        XLHC_TONGDAT_DOITUONG oTD = null;
                        if (lstCheck.Count > 0)
                        {
                            oTD = lstCheck[0];
                        }
                        else
                        {
                            oTD = new XLHC_TONGDAT_DOITUONG();
                        }
                        oTD.TONGDATID = TongdatID;
                        oTD.DUONGSUID = DuongsuID;
                        oTD.MATUCACH = Item.Cells[1].Text;
                        oTD.HINHTHUCGUI = 1;
                        oTD.TRANGTHAI = 1;
                        oTD.NGAYGUI = DateTime.Now;
                        oTD.NGAYNHANTONGDAT = DateTime.Now;
                        if (lstCheck.Count == 0)
                            dt.XLHC_TONGDAT_DOITUONG.Add(oTD);
                        dt.SaveChanges();
                        //Gửi sang hệ thống ĐKK
                        List<DONKK_DON_VBTONGDAT> lstDKK = dkk.DONKK_DON_VBTONGDAT.Where(x => x.BIEUMAUID == BMID && x.MALOAIVUVIEC == ENUM_LOAIAN.BPXLHC && x.VUVIECID == DONID && x.DUONGSUID == DuongsuID).ToList();
                        DONKK_DON_VBTONGDAT oVBTD = new DONKK_DON_VBTONGDAT();
                        if (lstDKK.Count > 0)
                        {
                            oVBTD = lstDKK[0];
                            oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                            oVBTD.TENFILE = oND.TENFILE;
                            oVBTD.LOAIFILE = oND.KIEUFILE;
                            dkk.SaveChanges();
                        }
                        else
                        {
                            oVBTD.VUVIECID = DONID;
                            oVBTD.BIEUMAUID = BMID;
                            oVBTD.MALOAIVUVIEC = ENUM_LOAIAN.BPXLHC;
                            oVBTD.DUONGSUID = DuongsuID;
                            oVBTD.TENVANBAN = ddlBieumau.SelectedItem.Text;
                            oVBTD.NGAYGUI = DateTime.Now;
                            oVBTD.NGAYNHANTONGDAT = DateTime.Now;
                            oVBTD.NOIDUNGFILE = oND.NOIDUNGFILE;
                            oVBTD.TENFILE = oND.TENFILE;
                            oVBTD.LOAIFILE = oND.KIEUFILE;
                            dkk.DONKK_DON_VBTONGDAT.Add(oVBTD);
                            dkk.SaveChanges();
                        }
                    }

                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                if (trTructuyen.Visible)
                    lbthongbao.Text = "Lưu và gửi tống đạt trực tuyến thành công!";
                else
                    lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        public void LoadGrid()
        {
            XLHC_DON_BL oBL = new XLHC_DON_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id), ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oDT = oBL.XLHC_TONGDAT_GETLIST(ID, ToaAnID);
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion

            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
            lbthongbao.Text = "";
        }
        public void xoa(decimal id)
        {
            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
            decimal _VALUE = 0;
            obj.DVCQG_TT_REMOVE_TONGDAT(id, "8", ref _VALUE);
            if (_VALUE == 1)
            {
                List<XLHC_TONGDAT_DOITUONG> lst = dt.XLHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == id).ToList();
                if (lst.Count > 0)
                {
                    dt.XLHC_TONGDAT_DOITUONG.RemoveRange(lst);
                }
                XLHC_TONGDAT oND = dt.XLHC_TONGDAT.Where(x => x.ID == id).FirstOrDefault();
                if (oND != null)
                {
                    dt.XLHC_TONGDAT.Remove(oND);
                }
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
            else
            {
                lbthongbao.Text = "Đã phát sinh giao dịch thanh toán, bạn không được Xóa!";
            }
        }
        public void loadedit(decimal ID)
        {
            cmdLammoi.Visible = true;
            bool IsShowVKS = false;
            trThemFile.Visible = false;
            decimal BIEUMAUID = 0, IS_TD_VKS = 0, FILEID = 0;
            DateTime? IS_TD_VKS_NGAY = null;
            XLHC_TONGDAT oND = dt.XLHC_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                BIEUMAUID = oND.BIEUMAUID + "" == "" ? 0 : (decimal)oND.BIEUMAUID;
                IS_TD_VKS = oND.IS_TD_VKS + "" == "" ? 0 : (decimal)oND.IS_TD_VKS;
                IS_TD_VKS_NGAY = oND.IS_TD_VKS_NGAY;
            }
            ddlBieumau.Visible = false;
            DM_BIEUMAU oBM = dt.DM_BIEUMAU.Where(x => x.ID == BIEUMAUID).FirstOrDefault();
            if (oBM != null)
            {
                lstTenBM.Text = oBM.TENBM;
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
            LoadDoituong(IsShowVKS, BIEUMAUID);
            if (FILEID > 0)
            {
                //XLHC_FILE oF = dt.XLHC_FILE.Where(x => x.ID == FILEID).FirstOrDefault();
                //if (oF != null) {
                //    if (oF.TENFILE !=null)
                //        lbtDownload.Visible = true;
                //    else
                //        lbtDownload.Visible = false;
                //}
                lbtDownload.Visible = true;
                //lbtDownload.Text = oND.TENFILE;
                hddFile.Value = FILEID + "";
            }
            else
                lbtDownload.Visible = false;

            ////Xem Van thu da tong dat(Ngay tong dat not null) thi khong duoc sưa
            //List<XLHC_TONGDAT_DOITUONG> lst = dt.XLHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == ID).ToList();
            //int vCheck = 0;
            //if (lst.Count > 0)
            //{
            //    for (int i = 0; i < lst.Count(); i++)
            //    {
            //        if (lst[i].TRANGTHAI == 1 && lst[i].NGAYGUI != null)
            //        {
            //            vCheck++;
            //        }
            //    }
            //    if (vCheck > 0)
            //    {
            //        cmdUpdate.Enabled = false;
            //        return;
            //    }
            //}
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    CountItem.Value = dgTructiep.Items.Count.ToString();
                    break;
                case "Xoa":
                    //Xem co quyen duoc xoa khong
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    //Xem Van thu da tong dat(Ngay tong dat not null) thi khong duoc xoa 
                    List<XLHC_TONGDAT_DOITUONG> lst = dt.XLHC_TONGDAT_DOITUONG.Where(x => x.TONGDATID == ND_id).ToList();
                    int vCheck = 0;
                    if (lst.Count > 0)
                    {
                        for (int i = 0; i < lst.Count(); i++)
                        {
                            #region thieu
                            decimal idDoiTuong = lst[i].ID;
                            var data = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == idDoiTuong && s.LOAIVUAN == ENUM_LOAIVUVIEC.BPXLHC);
                            if (lst[i].TRANGTHAI == 1 && lst[i].HINHTHUCGUI == 4 && data != null)
                            {
                                vCheck++;
                            }
                            #endregion
                        }
                        if (vCheck > 0)
                        {
                            lbthongbao.Text = "Bạn không được xóa khi văn bản đã được ủy thác!";
                            return;
                        }
                    }
                    xoa(ND_id);
                    ResetControls();
                    break;
            }
        }
        #region "Phân trang"

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
            if (BieuMauID == 0)
            {
                if (ddlBieumau.SelectedValue == "0")
                {
                    return;
                }
                decimal IDFILE = Convert.ToDecimal(ddlBieumau.SelectedValue);
                DM_QD_QUYETDINH oF = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDFILE).FirstOrDefault();
                if (oF != null) BMID = oF.TEN + "" == "" ? 0 : (decimal)oF.ID;
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
            #region Van thu se thuc hiên viec tong dat
            //if (IS_TD_VKS == 1)
            //{
            //    //trVKS.Visible = true;
            //    if (IsShowVKS)
            //    {
            //        rdbIsVKS.SelectedValue = "1";
            //        lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = true;
            //    }
            //    else
            //    {
            //        rdbIsVKS.SelectedValue = "0";
            //        lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
            //    }
            //}
            //else
            //{
            //    //trVKS.Visible = false;
            //    rdbIsVKS.SelectedValue = "0";
            //    lblVKSNgaygui.Visible = txtVKS_Ngaygui.Visible = div_VKS_NgayNhan.Visible = txtVKS_NgayNhan.Visible = false;
            //}
            #endregion
            XLHC_DON_BL oBL = new XLHC_DON_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oDTDS = null;
            if (hddIsTructuyen.Value == "1")
            {
                trTructuyen.Visible = true;
            }
            if (IS_TD_DUONGSU == 1)
            {
                oDTDS = oBL.XLHC_TONGDAT_DOITUONG_GETBY(DONID, TOAANID, BMID, 0);
                trDuongsu.Visible = true;
            }
            else if (IS_TD_NGUYENDON == 1 && IS_TD_DUONGSU != 1)
            {
                oDTDS = oBL.XLHC_TONGDAT_DOITUONG_GETBY(DONID, TOAANID, BMID, 1);
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
                            #region Thiều
                            rTructiep["QUOCGIA"] = r["QUOCGIA"];
                            rTructiep["COQUAN"] = r["COQUAN"];
                            rTructiep["NOIDUNG"] = r["NOIDUNG"];
                            rTructiep["KETQUAUTTP"] = r["KETQUAUTTP"];
                            rTructiep["TONGDAT_DOITUONG"] = r["TONGDAT_DOITUONG"];
                            #endregion
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
                    dgTructiep.DataSource = oDTDS;
                    CountItem.Value = oDTDS.Rows.Count.ToString();
                    dgTructiep.DataBind();

                }
            }
            if (dgTructiep.Items.Count == 0) trDuongsu.Visible = false;
            if (dgTructuyen.Items.Count == 0) trTructuyen.Visible = false;
        }
        #region Thiều
        private void DataCombox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            var dataketquauttp = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME("KETQUAUT");
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                ddlQuocGiaUT.DataSource = dtQuoctich;
                ddlQuocGiaUT.DataTextField = "TEN";
                ddlQuocGiaUT.DataValueField = "ID";
                ddlQuocGiaUT.DataBind();
                ddlQuocGiaUT.Items.Insert(0, new ListItem("---Chọn---", "0"));

                ddlketquauttp.DataSource = dataketquauttp;
                ddlketquauttp.DataTextField = "TEN";
                ddlketquauttp.DataValueField = "ID";
                ddlketquauttp.DataBind();
                ddlketquauttp.Items.Insert(0, new ListItem("---Chọn---", "0"));

                ddlketquauttp.ToolTip = Item.Cells[0].Text;
            }
        }
        #endregion 
        private DataTable CreateTable()
        {
            DataTable oDT = new DataTable();
            oDT.Columns.Add(new DataColumn("ID", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("TUCACHTOTUNG_MA", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("TENDUONGSU", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("TRANGTHAI", Type.GetType("System.Decimal")));
            oDT.Columns.Add(new DataColumn("NGAYGUI", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("NGAYNHANTONGDAT", Type.GetType("System.DateTime")));
            oDT.Columns.Add(new DataColumn("TENTCTT", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("HINHTHUCGUI", Type.GetType("System.String")));
            #region Thiều 
            oDT.Columns.Add(new DataColumn("QUOCGIA", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("COQUAN", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("NOIDUNG", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("KETQUAUTTP", Type.GetType("System.String")));
            oDT.Columns.Add(new DataColumn("TONGDAT_DOITUONG", Type.GetType("System.Decimal")));
            #endregion
            oDT.AcceptChanges();
            return oDT;
        }
        protected void ddlBieumau_SelectedIndexChanged(object sender, EventArgs e)
        {

            lbthongbao.Text = "";
            trThemFile.Visible = false;
            LoadDoituong(false, 0);
            #region thiều
            DataCombox();
            #endregion
            lbtDownload.Visible = false;

            if (ddlBieumau.SelectedValue != "0")
            {
                decimal IDFILE = Convert.ToDecimal(ddlBieumau.SelectedValue);
                XLHC_TONGDAT oF = dt.XLHC_TONGDAT.Where(x => x.ID == IDFILE).FirstOrDefault();
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
            //Manhnd bo 04/8/2021 Thư ky chi xac nhan se tong dat cho ai. còn Van thu se nhap ngay Tong dat
            CheckBox chk = (CheckBox)sender;
            IsHideColumn = true;
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                CheckBox chkIsSend = (CheckBox)Item.FindControl("chkIsSend");
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");

                #region Thiều 
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                Label lblQuocGia = (Label)Item.FindControl("lblQuocGia");
                Label lblNoidung = (Label)Item.FindControl("lblNoidung");
                Label lblCoquan = (Label)Item.FindControl("lblCoquan");
                #endregion

                //kiểm tra 

                string vHINHTHUCGUI = ddlHinhthucgui.SelectedValue;
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {

                    if (chk.Checked)
                    {
                        ddlHinhthucgui.Visible = ddlHinhthucgui.Enabled = true;
                        if (ddlHinhthucgui.SelectedValue == "5")
                        {
                            //txtNgaygui.Enabled = true;
                            txtNgayNhan.Enabled = true;
                        }
                        else
                            txtNgaygui.Enabled = txtNgayNhan.Enabled = false;
                        //if (txtNgaygui.Text == "")
                        //    txtNgaygui.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        #region Thiều 
                        if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
                        {
                            IsHideColumn = false;
                            ddlQuocGiaUT.Visible = true;
                            ddlketquauttp.Visible = true;
                            txtCoquan.Visible = true;
                            txtNoidung.Visible = true;
                            lblQuocGia.Visible = true;
                            lblNoidung.Visible = true;
                            lblCoquan.Visible = true;
                            txtNgaygui.Enabled = true;
                            txtNgayNhan.Enabled = true;

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



                    }
                    else
                    {
                        txtNgaygui.Enabled = txtNgayNhan.Enabled = false;
                        ddlHinhthucgui.Visible = ddlHinhthucgui.Enabled = false;

                        ddlQuocGiaUT.Visible = false;
                        ddlketquauttp.Visible = false;
                        txtCoquan.Visible = false;
                        txtNoidung.Visible = false;

                        lblQuocGia.Visible = false;
                        lblNoidung.Visible = false;
                        lblCoquan.Visible = false;

                        txtNgaygui.Enabled = false;
                        txtNgayNhan.Enabled = false;

                        txtNgaygui.Text = "";
                        txtNgayNhan.Text = "";
                        ddlHinhthucgui.SelectedValue = "2";
                        ddlQuocGiaUT.SelectedIndex = 0;
                        txtCoquan.Text = "";
                        txtNoidung.Text = "";
                        ddlketquauttp.SelectedIndex = 0;
                    }



                    #endregion
                }
                else
                {
                    //lúc sửa
                    if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
                    {
                        IsHideColumn = false;
                    }
                }

            }

            #region Thiều
            if (!chk.Checked)
            {
                DataGrid dtt = dgTructiep;
                if (IsHideColumn)
                {
                    dtt.Columns[15].Visible = false;
                    dtt.Columns[16].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn)
                {
                    dtt.Columns[15].Visible = true;
                    dtt.Columns[16].Visible = true;
                    check = 0;
                    IsHideColumn = false;
                }
            }
            #endregion
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
            XLHC_TONGDAT oF = dt.XLHC_TONGDAT.Where(x => x.ID == IDFILE).FirstOrDefault();
            if (oF != null)
            {
                if (oF.TENFILE != null)
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oF.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oF.TENFILE + "&Extension=" + oF.KIEUFILE + "';", true);
                }
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && oT.TOAANID + "" == Session[ENUM_SESSION.SESSION_DONVIID] + "")
                    {
                        lblSua.Text = "Xem chi tiết";
                        lbtXoa.Visible = false;
                    }
                }

            }
        }


        
        bool IsHideColumn = false;
        int check = 0;
        protected void dgTructiep_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DataGrid dataGrid = (DataGrid)sender;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                CheckBox chkIsSend = (CheckBox)e.Item.FindControl("chkIsSend");
                DropDownList ddlHinhthucgui = (DropDownList)e.Item.FindControl("ddlHinhthuc");


                TextBox txtNgaygui = (TextBox)e.Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)e.Item.FindControl("txtNgayNhan");
                string vHINHTHUCGUI = e.Item.Cells[2].Text;
                string vNgaygui = rowView["NGAYGUI"].ToString();

                ddlHinhthucgui.SelectedValue = vHINHTHUCGUI;

                //thêm đoạn code Thiều: đẩy dữ liệu lên form khi mà sửa
                #region Thiều 

                if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
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
                    dataGrid.Columns[15].Visible = false;
                    dataGrid.Columns[16].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn && (Convert.ToInt32(string.IsNullOrEmpty(CountItem.Value) ? "0" : CountItem.Value) - 1) == (e.Item.ItemIndex))
                {
                    dataGrid.Columns[15].Visible = true;
                    dataGrid.Columns[16].Visible = true;
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
                ddlQuocGiaUT.Items.Insert(0, new ListItem("---Chọn---", "0"));

                ddlketquauttp.DataSource = dataketquauttp;
                ddlketquauttp.DataTextField = "TEN";
                ddlketquauttp.DataValueField = "ID";
                ddlketquauttp.DataBind();
                ddlketquauttp.Items.Insert(0, new ListItem("---Chọn---", "0"));
                ddlketquauttp.ToolTip = e.Item.Cells[0].Text;
                if (chkIsSend.Checked)
                {
                    decimal Id = Convert.ToDecimal(e.Item.Cells[7].Text);
                    //kiểm tra 
                    var uttpDi = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == Id);
                    if (uttpDi != null)
                    {

                        if (uttpDi.NGAYNHANUTTPCAPDUOI.HasValue)
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
                        if (vHINHTHUCGUI != "3" && vHINHTHUCGUI != "4")
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

                #endregion
                if (vHINHTHUCGUI == "5")
                {
                    txtNgaygui.Visible = true;
                    txtNgayNhan.Visible = true;
                    txtNgaygui.Enabled = false;
                    txtNgayNhan.Enabled = true;
                }
                else
                {

                    txtNgaygui.Visible = true;
                    txtNgayNhan.Visible = true;

                    if (vHINHTHUCGUI == "3")
                    {
                        chkIsSend.Enabled = true;
                    }
                    else if (vHINHTHUCGUI == "4")
                    {
                        decimal Id = Convert.ToDecimal(e.Item.Cells[7].Text);
                        //kiểm tra 
                        var uttpDi = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.IDDOITUONGTONGDAT == Id);
                        if (uttpDi == null)
                        {
                            //cấp trên chưa làm gì được sửa
                            chkIsSend.Enabled = true;
                        }
                        else
                        {
                            chkIsSend.Enabled = false;
                        }
                    }
                    else
                    {


                    }
                }
                #region Thiều 
                if (vHINHTHUCGUI == "3")
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
                    txtNgayNhan.Enabled = true;
                    ddlketquauttp.Enabled = true;
                    ddlketquauttp.Visible = true;
                }
                #endregion
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
        #region Thiều 
        protected void ddlQuocGiaUT_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlketquauttp_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        #endregion

        #region Thieu
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
                                txtNgaygui.Text = "";
                            }
                        }


                    }

                }
            }
        }
        #endregion
        protected void ddlHinhthuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            foreach (DataGridItem Item in dgTructiep.Items)
            {
                TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                TextBox txtNgayNhan = (TextBox)Item.FindControl("txtNgayNhan");
                DropDownList ddlHinhthucgui = (DropDownList)Item.FindControl("ddlHinhthuc");
                //Thêm đoạn code-thiều
                #region Thiều 
                DropDownList ddlQuocGiaUT = (DropDownList)Item.FindControl("ddlQuocGiaUT");
                DropDownList ddlketquauttp = (DropDownList)Item.FindControl("ddlketquauttp");
                TextBox txtCoquan = (TextBox)Item.FindControl("txtCoquan");
                TextBox txtNoidung = (TextBox)Item.FindControl("txtNoidung");
                Label lblQuocGia = (Label)Item.FindControl("lblQuocGia");
                Label lblNoidung = (Label)Item.FindControl("lblNoidung");
                Label lblCoquan = (Label)Item.FindControl("lblCoquan");
                #endregion

                string vHINHTHUCGUI = ddlHinhthucgui.SelectedValue;


                //Thêm đoạn code-thiều nêu check hình thức gửi
                #region Thiều
                if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
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
                    dgTructiep.Columns[15].Visible = false;
                    dgTructiep.Columns[16].Visible = false;
                    check = 0;
                    IsHideColumn = false;
                }
                else if (!IsHideColumn && count == (Item.ItemIndex + 1))
                {
                    dgTructiep.Columns[15].Visible = true;
                    dgTructiep.Columns[16].Visible = true;
                    check = 0;
                    IsHideColumn = false;
                }


                if (vHINHTHUCGUI == "3" || vHINHTHUCGUI == "4")
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
                if (vHINHTHUCGUI == "3")
                {
                    txtNgayNhan.Enabled = true;
                    ddlketquauttp.Visible = true;
                    ddlketquauttp.Enabled = true;

                }
                if (ddl == ddlHinhthucgui)
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
                    txtNgayNhan.Enabled = true;
                    txtNgayNhan.Text = "";
                }
                #endregion
            }
        }
    }
}