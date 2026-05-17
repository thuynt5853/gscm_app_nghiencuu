using BL.GSTP;
using BL.GSTP.AHS;
using DAL.GSTP;
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
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class KhangCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadGrid();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }
        private void LoadCombobox()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            //Load người kháng cáo
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--Chọn--", "0"));
            LoadQD_BA();

            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlGQ_Thamphan.DataSource = oCBDT;
            ddlGQ_Thamphan.DataTextField = "MA_TEN";
            ddlGQ_Thamphan.DataValueField = "ID";
            ddlGQ_Thamphan.DataBind();
            ddlGQ_Thamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            // Load yêu cầu
            LoadCheckListYeuCauKhangCao();
        }
        private void LoadQD_BA()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (rdbLoaiKC.SelectedValue == "0")
            {
                ddlSOQDBA.DataSource = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYBANAN).ToList();
                ddlSOQDBA.DataTextField = "SOBANAN";
                ddlSOQDBA.DataValueField = "ID";
                ddlSOQDBA.DataBind();
            }
            else
            {
                ddlSOQDBA.DataSource = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYQD).ToList();
                ddlSOQDBA.DataTextField = "SOQUYETDINH";
                ddlSOQDBA.DataValueField = "ID";
                ddlSOQDBA.DataBind();
            }
            LoadQD_BA_Info();
        }
        private void LoadCheckListYeuCauKhangCao()
        {
            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkYeuCauKC.DataSource = tbl;
                chkYeuCauKC.DataTextField = "TEN";
                chkYeuCauKC.DataValueField = "ID";
                chkYeuCauKC.DataBind();
            }
        }
        private void LoadQD_BA_Info()
        {
            if (ddlSOQDBA.Items.Count == 0) return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA.Text = ""; }
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA.Text = ""; }
            }
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaAnQD.Text = oToaAn.TEN; }
                else { txtToaAnQD.Text = ""; }
            }
            else
            {
                txtToaAnQD.Text = "";
            }
        }
        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SOTHAM_KHANGCAO_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int Total = Convert.ToInt32(oDT.Rows.Count), pageSize = 20;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.PageSize = pageSize;
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
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
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
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
        private void ResetControls()
        {
            lbthongbao.Text = "";
            rdbNguoiKCLoai.SelectedValue = "1";
            txtNgayvietdon.Text = txtNgaykhangcao.Text = "";
            ddlNguoikhangcao.SelectedIndex = 0;
            rdbLoaiKC.SelectedValue = "0";
            rdbQuahan.SelectedValue = "0";
            LoadQD_BA();
            txtNoidung.Text = "";
            if (chkYeuCauKC.Items.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKC.Items)
                {
                    item.Selected = false;
                }
            }
            rdbMienAnphi.SelectedValue = "0";
            txtSobienlai.Text = "";
            txtAnphi.Text = "";
            txtNgaynopanphi.Text = "";
            txtNgaygiaiquyet.Text = "";
            txtGQGhichu.Text = "";
            ddlGQ_Thamphan.SelectedIndex = 0;
            rdbChapnhan.SelectedValue = "1";
            txtGQGhichu.Text = "";
            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;
        }
        private bool CheckValid()
        {
            if (txtNgayvietdon.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayvietdon.Text) == false)
            {
                lbthongbao.Text = "Ngày viết đơn phải theo định dạng (dd/MM/yyyy)!";
                txtNgayvietdon.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
            {
                lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không theo định dạng (dd/MM/yyyy)!";
                txtNgaykhangcao.Focus();
                return false;
            }

            if (ddlNguoikhangcao.SelectedIndex == 0)
            {
                lbthongbao.Text = "Chưa chọn người kháng cáo!";
                ddlNguoikhangcao.Focus();
                return false;
            }
            bool isSelected = false;
            foreach (ListItem item in chkYeuCauKC.Items)
            {
                if (item.Selected)
                {
                    isSelected = true;
                    break;
                }
            }
            if (!isSelected)
            {
                lbthongbao.Text = "Bạn chưa chọn yêu cầu kháng cáo!";
                return false;
            }

            if (ddlSOQDBA.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn số QĐ/BA";
                return false;
            }
            if (txtSobienlai.Text.Trim().Length > 20)
            {
                lbthongbao.Text = "Số biên lai không quá 20 ký tự. Hãy nhập lại!";
                txtSobienlai.Focus();
                return false;
            }
            if (txtNgaynopanphi.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgaynopanphi.Text) == false)
            {
                lbthongbao.Text = "Ngày nộp án phí phải theo định dạng (dd/MM/yyyy)!";
                txtNgaynopanphi.Focus();
                return false;
            }
            if (txtNgaygiaiquyet.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgaygiaiquyet.Text) == false)
            {
                lbthongbao.Text = "Ngày giải quyết phải theo định dạng (dd/MM/yyyy)!";
                txtNgaygiaiquyet.Focus();
                return false;
            }
            if (txtGQGhichu.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Ghi chú kết quả giải quyết kháng cáo của tòa Phúc thẩm không quá 250 ký tự. Hãy nhập lại!";
                txtGQGhichu.Focus();
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                AHS_SOTHAM_KHANGCAO oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new AHS_SOTHAM_KHANGCAO();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.VUANID = VuAnID;
                oND.NGUOIKCLOAI = Convert.ToDecimal(rdbNguoiKCLoai.SelectedValue);
                oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGUOIKCID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan.SelectedValue);
                oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oVuAn.TOAANID;
                oND.NOIDUNGKHANGCAO = txtNoidung.Text;
                oND.ISMIENANPHI = Convert.ToDecimal(rdbMienAnphi.SelectedValue);
                oND.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                oND.SOBIENLAI = txtSobienlai.Text;
                oND.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgaynopanphi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynopanphi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.GQ_NGAY = (String.IsNullOrEmpty(txtNgaygiaiquyet.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaygiaiquyet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.GQ_THAMPHANID = Convert.ToDecimal(ddlGQ_Thamphan.SelectedValue);
                oND.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                oND.GQ_GHICHU = txtGQGhichu.Text;

                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE =Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                }
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_KHANGCAO.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                // Update yêu cầu kháng cáo
                UpdateYeuCauKhangCao(oND.ID);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        private void UpdateYeuCauKhangCao(Decimal KhangCaoID)
        {
            AHS_SOTHAM_KHANGCAO_YEUCAU obj = null;
            // lấy ra tất cả các yêu cầu cũ
            string StrKhangCaoYC = "|";
            if (KhangCaoID > 0)
            {
                List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == KhangCaoID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (AHS_SOTHAM_KHANGCAO_YEUCAU item in lst)
                        StrKhangCaoYC += item.YEUCAUID + "|";
                }
            }
            // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
            Boolean IsNew = false;
            decimal yeuCauID = 0;
            foreach (ListItem item in chkYeuCauKC.Items)
            {
                IsNew = false;
                if (item.Selected)
                {
                    if (StrKhangCaoYC == "|")
                        IsNew = true;
                    else
                    {
                        if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                        {
                            yeuCauID = Convert.ToDecimal(item.Value);
                            obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == KhangCaoID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                            if (obj != null)
                            {
                                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                obj.NGAYSUA = DateTime.Now;
                                dt.SaveChanges();
                            }
                            StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                            IsNew = false;
                        }
                        else
                            IsNew = true;
                    }
                    if (IsNew)
                    {
                        obj = new AHS_SOTHAM_KHANGCAO_YEUCAU();
                        obj.KHANGCAOID = KhangCaoID;
                        obj.YEUCAUID = Convert.ToDecimal(item.Value);
                        obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        obj.NGAYTAO = DateTime.Now;
                        dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Add(obj);
                        dt.SaveChanges();
                    }
                }
            }
            // yêu cầu còn lại cần phải xóa
            if (StrKhangCaoYC != "|")
            {
                String[] arr = StrKhangCaoYC.Split('|');
                foreach (String item in arr)
                {
                    if (item.Length > 0)
                    {
                        yeuCauID = Convert.ToDecimal(item);
                        obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                        if (obj != null)
                        {
                            dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Remove(obj);
                            dt.SaveChanges();
                        }
                    }
                }
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void xoa(decimal id)
        {
            AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {   //Luu thong tin Kháng cáo Sơ thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(oND);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Kháng cáo Sơ thẩm án Hình sự", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Kháng cáo Sơ thẩm
                dt.AHS_SOTHAM_KHANGCAO.Remove(oND);
                List<AHS_SOTHAM_KHANGCAO_YEUCAU> listKcyc = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == id).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                if (listKcyc != null && listKcyc.Count > 0)
                {
                    dt.AHS_SOTHAM_KHANGCAO_YEUCAU.RemoveRange(listKcyc);
                }
            }
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                rdbNguoiKCLoai.SelectedValue = oND.NGUOIKCLOAI.ToString();
                txtNgayvietdon.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                txtNgaykhangcao.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                ddlNguoikhangcao.SelectedValue = oND.NGUOIKCID.ToString();
                rdbLoaiKC.SelectedValue = oND.LOAIKHANGCAO.ToString();
                ddlSOQDBA.SelectedValue = oND.SOQDBA.ToString();
                rdbQuahan.SelectedValue = oND.ISQUAHAN.ToString();
                txtNgayQDBA.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                if (oToaAn != null) { txtToaAnQD.Text = oToaAn.TEN; } else { txtToaAnQD.Text = ""; }
                txtNoidung.Text = oND.NOIDUNGKHANGCAO;
                if (oND.TENFILE != "")
                {
                    lbtDownload.Visible = true;
                }
                else
                { lbtDownload.Visible = false; }
                FillYeuCauKC(ID);
                rdbMienAnphi.SelectedValue = oND.ISMIENANPHI.ToString();
                txtAnphi.Text = string.IsNullOrEmpty(oND.ANPHI + "") ? "" : oND.ANPHI.ToString();
                txtSobienlai.Text = oND.SOBIENLAI;
                txtNgaynopanphi.Text = string.IsNullOrEmpty(oND.NGAYNOPANPHI + "") ? "" : ((DateTime)oND.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);
                txtNgaygiaiquyet.Text = string.IsNullOrEmpty(oND.GQ_NGAY + "") ? "" : ((DateTime)oND.GQ_NGAY).ToString("dd/MM/yyyy", cul);
                ddlGQ_Thamphan.SelectedValue = string.IsNullOrEmpty(oND.GQ_THAMPHANID + "") ? "0" : oND.GQ_THAMPHANID.ToString();
                rdbChapnhan.SelectedValue = string.IsNullOrEmpty(oND.GQ_ISCHAPNHAN + "") ? "0" : oND.GQ_ISCHAPNHAN.ToString();
                txtGQGhichu.Text = oND.GQ_GHICHU + "";
            }
        }
        private void FillYeuCauKC(Decimal KhangCaoID)
        {
            List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == KhangCaoID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
            if (lst != null && lst.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKC.Items)
                {
                    item.Selected = false;
                    foreach (AHS_SOTHAM_KHANGCAO_YEUCAU obj in lst)
                    {
                        if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                            item.Selected = true;
                    }
                }
            }
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
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA();
        }
        protected void ddlSOQDBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_Info();
        }
    }
}