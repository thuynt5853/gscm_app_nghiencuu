using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.SoTham.BanAnST.Popup
{
    public partial class pToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        public Decimal BiCanID = 0, BanAnID = 0, VuAnID = 0;
        public decimal NhomHinhPhatBS = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
            {
                BanAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
                VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                NhomHinhPhatBS = dt.DM_DATAITEM.Where(x => x.MA == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG).SingleOrDefault().ID;

                if (!IsPostBack)
                {
                    BiCanID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");

                    hddBanAnID.Value = BanAnID.ToString();
                    CheckQuyen();
                    LoadDrop();
                    LoadDsToiDanhByBiCan();
                    LoadBtnChonTDC();
                    LoadToiDanhChinh();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        private HashSet<decimal> GetListToiDanhST(decimal BiCanID)
        {
            return (
                from bc in dt.AHS_BICANBICAO
                join ba_dct in dt.AHS_SOTHAM_BANAN_DIEU_CHITIET
                    on bc.ID equals ba_dct.BICANID into ba_dct_left
                from ba_dct in ba_dct_left.DefaultIfEmpty()
                join td in dt.DM_BOLUAT_TOIDANH
                    on ba_dct.TOIDANHID equals td.ID
                where td.KHOAN == null && bc.ID == BiCanID
                select td.ID
            )
            .Distinct()
            .ToHashSet();
        }
        void CheckQuyen()
        {
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN + "";
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";

                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                return;
            }
            //AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            //if (kc != null)
            //{
            //    lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
            //    Cls_Comon.SetButton(cmdThemDieuLuat, false);
            //    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
            //    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
            //    Cls_Comon.SetButton(cmdChonDieuLuat, false);
            //}
            //AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            //if (kn != null)
            //{
            //    lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
            //    Cls_Comon.SetButton(cmdThemDieuLuat, false);
            //    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
            //    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
            //    Cls_Comon.SetButton(cmdChonDieuLuat, false);
            //}
            AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdThemDieuLuat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                    Cls_Comon.SetButton(cmdChonDieuLuat, false);
                    Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGCAO kc2 = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kc2 != null)
                {
                    lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdThemDieuLuat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                    Cls_Comon.SetButton(cmdChonDieuLuat, false);
                    Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                {
                    lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdThemDieuLuat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                    Cls_Comon.SetButton(cmdChonDieuLuat, false);
                    Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGNGHI kn2 = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kn2 != null)
                {
                    lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdThemDieuLuat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                    Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                    Cls_Comon.SetButton(cmdChonDieuLuat, false);
                    Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                    return;
                }
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                return;
            }

            BL.GSTP.THA.THA_BIAN_BL objBL = new BL.GSTP.THA.THA_BIAN_BL();
            if (objBL.CHECK_THA_BIAN_BICAO_DONGBO(BiCanID))
            {
                lbthongbao.Text = "Bị cáo đã đồng bộ quyết định thi hành án. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                Cls_Comon.SetButton(btnChonToiDanhChinh, false);
                return;
            }
        }
        //su kien xay ra sau khi thuc hien xong sk gay postback
        protected void Page_PreRender(object sender, EventArgs e)
        {
            Decimal row_hinhphat = 0;
            //------------------------
            Decimal CurrToiDanhId = (string.IsNullOrEmpty(hddCurrToiDanhID.Value)) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
            foreach (RepeaterItem item in rpt.Items)
            {
                HiddenField hddToiDanh = (HiddenField)item.FindControl("hddToiDanh");
                LinkButton lk = (LinkButton)item.FindControl("lk");
                Image Image = (Image)item.FindControl("Image");
                if (CurrToiDanhId == Convert.ToDecimal(hddToiDanh.Value))
                {
                    lk.Visible = false;
                    Image.Visible = true;
                    Image.ImageUrl = "../../../../../UI/img/check.png";
                    Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
                }
                else
                {
                    Image.Visible = false;
                    lk.Visible = true;
                }
            }
            //-------------------------------
            decimal CurrHinhPhatID = Convert.ToDecimal(hddHinhPhatChange.Value);
            if (CurrHinhPhatID > 0)
            {
                foreach (RepeaterItem item in rptHPChinh.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);

                    Panel pnZoneHinhPhat = (Panel)item.FindControl("pnZoneHinhPhat");

                    Panel pnThoiGianThuThach = (Panel)item.FindControl("pnThoiGianThuThach");
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                            pnZoneHinhPhat.Enabled = chk.Checked = false;
                        else
                        {
                            pnZoneHinhPhat.Enabled = true;
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                            try
                            {
                                CheckBox chkAnTreo = (CheckBox)item.FindControl("chkAnTreo");
                                if (chkAnTreo.Checked)
                                {
                                    pnThoiGianThuThach.Visible = true;
                                    TextBox txtTGTT_Nam = (TextBox)item.FindControl("txtTGTT_Nam");
                                    Cls_Comon.SetFocus(this, this.GetType(), txtTGTT_Nam.ClientID);
                                }
                                else
                                    pnThoiGianThuThach.Visible = false;
                            }
                            catch (Exception exx) { }
                        }
                    }
                }
                foreach (RepeaterItem item in rptQDKhac.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                            chk.Checked = false;
                        else
                        {
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                        }
                    }
                }
                Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
            }
        }

        void LoadDrop()
        {
            List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
            if (lstBC != null && lstBC.Count > 0)
            {
                dropBiCao.Items.Clear();
                foreach (AHS_BICANBICAO obj in lstBC)
                    dropBiCao.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                try
                {
                    if (Request["bID"] != null)
                        dropBiCao.SelectedValue = Request["bID"] + "";
                }
                catch (Exception ex) { }
            }
            //----------------------------------------
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                            && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            if (lst != null && lst.Count > 0)
            {
                if (lstBC.Count > 1)
                    dropBoLuat.Items.Add(new ListItem("--------Chọn--------", "0"));
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }
        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/AHS/SoTham/BanAnST/popup/pToiDanh.aspx?aID=" + BanAnID + "&bID=" + dropBiCao.SelectedValue);
        }
        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("BanAnSoTham.aspx");
        }

        //----------------------------------------------
        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            String Diem = txtDiem.Text.Trim();
            string Khoan = txtKhoan.Text.Trim();
            String Dieu = txtDieu.Text.Trim();

            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            DataTable tbl = objBL.SearchChinhXacTheoDK(luatid, Diem, Khoan, Dieu);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.Rows[0];
                SaveToiDanh(row);
            }
            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
        }

        void SaveToiDanh(DataRow rowToiDanh)
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid = Convert.ToDecimal(rowToiDanh["ID"] + "");

            //Update_ToiDanh_ChiTiet(toidanhid, 0);
            //lstMsgT.Text = "Lưu điều luật áp dụng cho bị can thành công!";


            //Lay ds cac cap cha cua toi danh duoc chon
            String ArrSapXep = "";
            String[] arrToiDanh = null;
            ArrSapXep = rowToiDanh["ArrSapXep"] + "";
            arrToiDanh = ArrSapXep.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh(toidanhid, 0);
                    }
                }
                dt.SaveChanges();
            }

            lstMsgT.Text = "Lưu điều luật áp dụng cho bị cáo thành công!";
        }

        void InsertToiDanh(Decimal toidanhid, decimal hinhphatid)
        {
            Boolean IsUpdate = false;
            DM_BOLUAT_TOIDANH objTD = null;
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            AHS_SOTHAM_BANAN_DIEU_CHITIET obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            try
            {
                obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                && x.BANANID == BanAnID
                                                                && x.TOIDANHID == toidanhid).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET(); }
            if (!IsUpdate)
            {
                obj.BANANID = BanAnID;
                obj.BICANID = BiCanID;
                obj.DIEULUATID = boluatid;
                obj.TOIDANHID = toidanhid;
                obj.HINHPHATID = hinhphatid;

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                AHS_SOTHAM_BANAN_DIEU_CHITIET checkISMAIN = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID && x.BANANID == BanAnID && x.ISMAIN == 1).FirstOrDefault<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                if (checkISMAIN == null && objTD.DIEM == null && objTD.KHOAN == null)
                {
                    obj.ISMAIN = 1;
                }
                else
                {
                    obj.ISMAIN = 0;
                }

                obj.TENTOIDANH = objTD.TENTOIDANH;

                obj.VUANID = VuAnID;

                if (hinhphatid > 0)
                {
                    decimal loai_hp = Convert.ToDecimal(dt.DM_HINHPHAT.Where(x => x.ID == hinhphatid).SingleOrDefault().LOAIHINHPHAT);
                    obj.LOAIHINHPHAT = loai_hp;
                    switch (Convert.ToInt16(loai_hp))
                    {
                        case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                            obj.TF_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                            obj.SH_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                            obj.TG_NGAY = 0;
                            obj.TG_THANG = 0;
                            obj.TG_NAM = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                            obj.K_VALUE1 = 0;
                            obj.K_VALUE2 = "";
                            break;
                        case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                            obj.TF_VALUE = 1;
                            break;
                    }
                }
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                dt.SaveChanges();
            }
        }

        //----------------------------------------------
        public string row_td_change = "";
        public void LoadDsToiDanhByBiCan()
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            ViewState["listToiDanhST"] = GetListToiDanhST(BiCanID);
            //--Load lai bo luat----DieuLuatID
            AHS_SOTHAM_BANAN_DIEU_CHITIET BL = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID && x.BANANID == BanAnID).FirstOrDefault();
            if (BL != null)
            {

                dropBoLuat.SelectedValue = BL.DIEULUATID.ToString();
            }

            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal loaiboluat = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU);
            DateTime ngaybh = DateTime.MinValue;
            string curr_textsearch = "";// txtTenToiDanh.Text.Trim();
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.GetAllPaging(BiCanID, BanAnID, boluatid, curr_textsearch, pageindex, page_size);
            // AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            // DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, boluatid, 0, "", pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                rpt.DataSource = null;
                rpt.DataBind();
                lblThongBaoHP.Text = "";
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                bool StatusButton = cmdSaveHinhPhat.Enabled;
                Cls_Comon.SetLinkButton(lbtXoa, StatusButton);

                int MaGiaiDoanVuAn = (string.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt32(hddGiaiDoanVuAn.Value);
                if (MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.PHUCTHAM || MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                var listToiDanhST = ViewState["listToiDanhST"] as HashSet<decimal>;
                var toiDanhID = DataBinder.Eval(e.Item.DataItem, "ToiDanhID");
                if (toiDanhID != null && listToiDanhST != null)
                {
                    var id = Convert.ToDecimal(toiDanhID);

                    if (listToiDanhST.Contains(id))
                    {
                        if (listToiDanhST.Count > 1)
                            Cls_Comon.SetLinkButton(lbtXoa, true);
                        else
                            Cls_Comon.SetLinkButton(lbtXoa, false);
                    }
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblThongBaoHP.Text = "";
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());

            switch (e.CommandName)
            {
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(curr_id);
                    Capnhat_AHS_TONGHOPHINHPHAT();
                    break;
                case "HinhPhat":
                    Response.Redirect("ChonToiDanh.aspx");
                    break;
                case "view":
                    //Chi hien khung chon hinh phat khi toidanh co CoHinhPhat = 1
                    hddHinhPhatChange.Value = hddGroupChange.Value = "0";
                    LoadHinhPhatTheoToiDanh(curr_id);
                    break;
            }
        }

        #region Load hinh phat theo toi danh
        void LoadHinhPhatTheoToiDanh(Decimal ToiDanhID)
        {
            hddCurrToiDanhID.Value = ToiDanhID.ToString();
            DM_BOLUAT_TOIDANH objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).SingleOrDefault();
            if (objTD != null)
            {
                int IsHinhPhat = String.IsNullOrEmpty(objTD.COHINHPHAT + "") ? 0 : Convert.ToInt16(objTD.COHINHPHAT);
                if (IsHinhPhat == 1)
                {
                    pnHinhPhat.Visible = true;
                    lttToiDanh.Text = "Cập nhật hình phạt";// + objTD.TENTOIDANH;

                    //---------Load 3 nhom dhp----------------------------
                    DM_DATAGROUP objG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.NHOMHINHPHAT).SingleOrDefault();
                    List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == objG.ID).ToList<DM_DATAITEM>();
                    if (lst != null && lst.Count > 0)
                    {
                        Decimal GroupID = 0;
                        foreach (DM_DATAITEM data in lst)
                        {
                            GroupID = data.ID;
                            switch (data.MA + "")
                            {
                                case ENUM_NHOMHINHPHAT.NHOM_HPCHINH:
                                    lttNhomHPChinh.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptHPChinh);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG:
                                    lttNhomHPBoSung.Text = data.TEN;
                                    try
                                    {
                                        LoadListHinhPhatBoSung(GroupID);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_QDKHAC:
                                    lttNhomQDKhac.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptQDKhac);
                                    }
                                    catch (Exception ex) { }
                                    break;
                            }
                        }
                    }
                }
                else
                    pnHinhPhat.Visible = false;
            }
        }
        void LoadHinhPhatTheoGroup(decimal GroupID, Repeater rptControl)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();

            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptControl.DataSource = lst;
                rptControl.DataBind();
            }
        }

        void LoadListHinhPhatBoSung(decimal GroupID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptHPBoSung.DataSource = lst;
                rptHPBoSung.DataBind();
            }
        }
        protected void rptHP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;
                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                decimal bican = Convert.ToDecimal(dropBiCao.SelectedValue);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                AHS_SOTHAM_BANAN_DIEU_CHITIET objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                if (group_id == NhomHinhPhatBS)
                {
                    chkAnTreo.Checked = false;
                    chk.Visible = false;
                    try
                    {
                        objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bican
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.HINHPHATID == hinhphat
                                                                             && x.ISCHANGE == 1
                                                                        ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    }
                    catch (Exception ex) { }
                }
                else
                {
                    chk.Visible = true;
                    try
                    {
                        objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bican
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.HINHPHATID == hinhphat
                                                                            && x.ISCHANGE == 0
                                                                        ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    }
                    catch (Exception ex) { }
                }
                if (objCT != null)
                {
                    hddGroupChange.Value = group_id.ToString();
                    if (group_id != NhomHinhPhatBS)
                    {
                        //chkAnTreo.Checked = true;
                        chk.Checked = true;
                        hddHinhPhatChange.Value = hinhphat.ToString();

                        int is_antreo = (string.IsNullOrEmpty(objCT.ISANTREO + "")) ? 0 : Convert.ToInt16(objCT.ISANTREO);
                        if (objCT.ISANTREO == 1)
                        {
                            chkAnTreo.Checked = true;
                            try
                            {
                                Panel pnThoiGianThuThach = (Panel)e.Item.FindControl("pnThoiGianThuThach");
                                pnThoiGianThuThach.Visible = true;

                                TextBox txtTGTT_Nam = (TextBox)e.Item.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)e.Item.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)e.Item.FindControl("txtTGTT_Ngay");
                                txtTGTT_Nam.Text = (String.IsNullOrEmpty(objCT.TGTT_NAM + "")) ? "0" : objCT.TGTT_NAM.ToString();
                                txtTGTT_Thang.Text = (String.IsNullOrEmpty(objCT.TGTT_THANG + "")) ? "0" : objCT.TGTT_THANG.ToString();
                                txtTGTT_Ngay.Text = (String.IsNullOrEmpty(objCT.TGTT_NGAY + "")) ? "0" : objCT.TGTT_NGAY.ToString();
                            }
                            catch (Exception ex) { }
                        }
                    }
                }
                else
                {
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        rdTrueFalse.Visible = true;
                        if (objCT != null)
                            rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(objCT.TF_VALUE + "")) ? "0" : objCT.TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : ((Int64)objCT.SH_VALUE).ToString("#,#", cul);
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        rdDefaultTrue.Visible = false;
                        if (objCT != null)
                            rdDefaultTrue.SelectedValue = "1";
                        break;
                }
            }
        }

        protected void cmdSaveHinhPhat_Click(object sender, EventArgs e)
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);

            DM_BOLUAT_TOIDANH dm = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            Decimal boluatid = (decimal)dm.LUATID;

            Decimal NhomHinhPhatChange = String.IsNullOrEmpty(hddGroupChange.Value) ? 0 : Convert.ToDecimal(hddGroupChange.Value);
            if (NhomHinhPhatChange > 0)
            {
                string manhom = dt.DM_DATAITEM.Where(x => x.ID == NhomHinhPhatChange).Single<DM_DATAITEM>().MA;
                if (manhom == ENUM_NHOMHINHPHAT.NHOM_HPCHINH)
                    Update_HinhPhatChinh(rptHPChinh, ToiDanhID, boluatid);
                else
                    Update_HinhPhatChinh(rptQDKhac, ToiDanhID, boluatid);
            }
            else
            {
                Update_HinhPhatChinh(rptHPChinh, ToiDanhID, boluatid);
                Update_HinhPhatChinh(rptQDKhac, ToiDanhID, boluatid);
            }
            Update_HinhPhatBS(rptHPBoSung, ToiDanhID, boluatid);
            lbthongbao.Text = "";

            try { Update_TongHopHP(); } catch (Exception ex) { }

            Capnhat_AHS_TONGHOPHINHPHAT();

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Cập nhật hình phạt cho bị cáo thành công!");
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        private void Capnhat_AHS_TONGHOPHINHPHAT()
        {
            try
            {
                AHS_TONGHOPHINHPHAT saveTHHP = new AHS_TONGHOPHINHPHAT();
                if (!saveTHHP.Capnhat_Tonghophinhphat_byVuanAndBicanid(2, VuAnID, BiCanID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                {
                    lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                    return;
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
                lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                return;
            }
        }

        void Update_TongHopHP()
        {
            Decimal CurrHinhPhatID = 0, th_HinhPhatID = 0;
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            AHS_SOTHAM_BANAN_DIEU_TONGHOP objTH = null;
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.TongHopToiDanhSoTham(BanAnID, BiCanID);
            int check_default_true = 0;

            int isupdate = 0;

            String MaHinhPhat = "", MaNhomHP = "";
            int MucDo_HinhPhat = 0;
            DM_HINHPHAT objHP = null;
            if (tbl != null && tbl.Rows.Count > 0)
            {
                bool IsMain = false;
                String StrEdit = ",";
                foreach (DataRow row in tbl.Rows)
                {
                    isupdate = 0;
                    IsMain = false;
                    check_default_true = 0;
                    CurrHinhPhatID = Convert.ToDecimal(row["HinhPhatID"] + "");
                    MaHinhPhat = row["MaHinhPhat"] + "";
                    MaNhomHP = row["MaNhomHP"] + "";
                    MucDo_HinhPhat = Convert.ToInt16(row["MUCDO"] + "");
                    //TUCHUNGTHAN, TUHINH                

                    if (MaNhomHP == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG)
                    {
                        IsMain = false;
                        try
                        {
                            objTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                   && x.BICANID == BiCanID
                                                                   && x.HINHPHATID == CurrHinhPhatID).FirstOrDefault();
                            if (objTH == null)
                                objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP();
                            else isupdate = 1;
                        }
                        catch (Exception ex) { objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP(); }
                    }
                    else
                    {
                        IsMain = true;
                        objTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                         && x.BICANID == BiCanID
                                                                         && x.ISMAIN == 1).FirstOrDefault();
                        if (objTH == null)
                            objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP();
                        else
                        {
                            th_HinhPhatID = (Decimal)objTH.HINHPHATID;

                            objHP = dt.DM_HINHPHAT.Where(x => x.ID == th_HinhPhatID).FirstOrDefault();
                            if (objHP != null)
                            {
                                if (objHP.MUCDO > MucDo_HinhPhat)
                                    isupdate = 1;
                                else
                                    isupdate = 2; // ko cho update hinh phat chinh
                            }
                        }
                    }
                    objTH.BANANID = BanAnID;
                    objTH.BICANID = BiCanID;
                    objTH.HINHPHATID = CurrHinhPhatID;
                    objTH.ISMAIN = (IsMain) ? 1 : 0; //hinh phat chinh/hp bo sung
                    obj.LOAIHINHPHAT = String.IsNullOrEmpty(row["LOAIHINHPHAT"] + "") ? 0 : Convert.ToDecimal(row["LOAIHINHPHAT"] + "");

                    //---------------------------------
                    objTH.TF_VALUE = String.IsNullOrEmpty(row["TF_VALUE"] + "") ? 0 : ((Convert.ToDecimal(row["TF_VALUE"] + "") > 1) ? 1 : 0);
                    if (objTH.TF_VALUE > 0)
                        check_default_true = 1;

                    //---------------------------------
                    objTH.SH_VALUE = String.IsNullOrEmpty(row["SH_VALUE"] + "") ? 0 : Convert.ToDecimal(row["SH_VALUE"] + "");
                    if (objTH.SH_VALUE > 0)
                        check_default_true = 1;

                    //---------------------------------
                    objTH.TG_NAM = String.IsNullOrEmpty(row["TG_NAM"] + "") ? 0 : Convert.ToDecimal(row["TG_NAM"] + "");
                    objTH.TG_THANG = String.IsNullOrEmpty(row["TG_THANG"] + "") ? 0 : Convert.ToDecimal(row["TG_THANG"] + "");
                    objTH.TG_NGAY = String.IsNullOrEmpty(row["TG_NGAY"] + "") ? 0 : Convert.ToDecimal(row["TG_NGAY"] + "");
                    if (objTH.TG_NAM > 0 || objTH.TG_NGAY > 0 || objTH.TG_THANG > 0)
                        check_default_true = 1;

                    objTH.TGTT_NAM = String.IsNullOrEmpty(row["TGTT_NAM"] + "") ? 0 : Convert.ToDecimal(row["TGTT_NAM"] + "");
                    objTH.TGTT_THANG = String.IsNullOrEmpty(row["TGTT_THANG"] + "") ? 0 : Convert.ToDecimal(row["TGTT_THANG"] + "");
                    objTH.TGTT_NGAY = String.IsNullOrEmpty(row["TGTT_NGAY"] + "") ? 0 : Convert.ToDecimal(row["TGTT_NGAY"] + "");
                    if (objTH.TGTT_NAM > 0 || objTH.TGTT_NGAY > 0 || objTH.TGTT_THANG > 0)
                    {
                        check_default_true = 1;
                        objTH.ISANTREO = 1;
                    }
                    else obj.ISANTREO = 0;

                    //---------------------------------
                    objTH.K_VALUE1 = String.IsNullOrEmpty(row["K_VALUE1"] + "") ? 0 : Convert.ToDecimal(row["K_VALUE1"] + "");
                    if (objTH.K_VALUE1 > 0)
                        check_default_true = 1;

                    objTH.K_VALUE2 = String.IsNullOrEmpty(row["K_VALUE2"] + "") ? "" : row["K_VALUE2"] + "";
                    if (!String.IsNullOrEmpty(objTH.K_VALUE2))
                        check_default_true = 1;

                    //---------------------------------
                    if (isupdate == 0)
                        dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Add(objTH);

                    if (isupdate < 2)
                        dt.SaveChanges();
                    StrEdit += objTH.ID.ToString() + ",";
                }

                //-------------------------------
                if (!String.IsNullOrEmpty(StrEdit))
                {
                    string temp = "";
                    List<AHS_SOTHAM_BANAN_DIEU_TONGHOP> lstTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                                                         && x.BICANID == BiCanID).ToList();
                    if (lstTH != null && lstTH.Count > 0)
                    {
                        foreach (AHS_SOTHAM_BANAN_DIEU_TONGHOP item in lstTH)
                        {
                            temp = "," + item.ID + ",";
                            if (!StrEdit.Contains(temp))
                            {
                                //Xoa dl 
                                dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Remove(item);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
        }
        #region Update hinh phat chinh, QDKhac
        AHS_SOTHAM_BANAN_DIEU_CHITIET obj;
        void Update_HinhPhatChinh(Repeater rpt, Decimal ToiDanhID, Decimal boluatid)
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal HinhPhatChinh = Convert.ToDecimal(hddHinhPhatChange.Value);
            Boolean IsUpdate = false;
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
                    CheckBox chk = (CheckBox)itemHP.FindControl("chk");
                    if (hinhphatid == HinhPhatChinh && chk.Checked == true)
                    {
                        try
                        {
                            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> listCheck = null;
                            listCheck = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                                 && x.BANANID == BanAnID
                                                                                 && x.TOIDANHID == ToiDanhID
                                                                                 && x.ISCHANGE == 0
                                                                                 ).ToList();
                            if (listCheck != null && listCheck.Count > 0)
                            {
                                obj = listCheck[0];
                                IsUpdate = true;
                                //foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET item in listCheck)
                                //{
                                //        if (item.HINHPHATID > 0 && item.HINHPHATID == hinhphatid)
                                //        {
                                //            IsUpdate = true;
                                //            obj = item;
                                //            break;
                                //        }
                                //        else
                                //            IsUpdate = false;
                                //}
                            }
                            else
                            {
                                IsUpdate = false;
                                obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                            }
                        }
                        catch (Exception ex)
                        {
                            obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                        }

                        //----------An treo & thoi gian thu thach----------------
                        obj.TGTT_NAM = 0;
                        obj.TGTT_THANG = 0;
                        obj.TGTT_NGAY = 0;
                        try
                        {
                            CheckBox chkAnTreo = (CheckBox)itemHP.FindControl("chkAnTreo");
                            obj.ISANTREO = (chkAnTreo.Checked) ? 1 : 0;

                            if (chkAnTreo.Checked)
                            {
                                TextBox txtTGTT_Nam = (TextBox)itemHP.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)itemHP.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)itemHP.FindControl("txtTGTT_Ngay");
                                obj.TGTT_NAM = String.IsNullOrEmpty(txtTGTT_Nam.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Nam.Text);
                                obj.TGTT_THANG = String.IsNullOrEmpty(txtTGTT_Thang.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Thang.Text);
                                obj.TGTT_NGAY = String.IsNullOrEmpty(txtTGTT_Ngay.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Ngay.Text);
                            }

                        }
                        catch (Exception exx) { }
                        //---------------------------------------
                        obj.ISCHANGE = 0;

                        obj.DIEULUATID = boluatid;
                        obj.TOIDANHID = ToiDanhID;
                        obj.HINHPHATID = hinhphatid;
                        obj.BANANID = BanAnID;
                        obj.BICANID = Convert.ToDecimal(dropBiCao.SelectedValue);
                        obj.VUANID = VuAnID;
                        GetValue(obj, itemHP);
                        if (!IsUpdate)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                        dt.SaveChanges();
                    }
                }
                catch (Exception ex) { }
            }
        }

        void GetValue(AHS_SOTHAM_BANAN_DIEU_CHITIET obj, RepeaterItem itemHP)
        {
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;

            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    obj.TF_VALUE = 1;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    obj.TF_VALUE = Convert.ToDecimal(rdTrueFalse.SelectedValue);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = (String.IsNullOrEmpty(txtSohoc.Text)) ? 0 : Convert.ToDecimal(txtSohoc.Text.Replace(".", ""));
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    break;
            }
        }

        protected void rptHPBoSung_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;

                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                decimal bican = Convert.ToDecimal(dropBiCao.SelectedValue);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                AHS_SOTHAM_BANAN_DIEU_CHITIET objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                chkAnTreo.Checked = false;

                try
                {
                    objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bican
                                                                        && x.BANANID == BanAnID
                                                                        && x.TOIDANHID == ToiDanhID
                                                                        && x.HINHPHATID == hinhphat
                                                                         && x.ISCHANGE == 1
                                                                    ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (objCT != null)
                    {
                        hddGroupChange.Value = group_id.ToString();
                        if (group_id != NhomHinhPhatBS)
                        {
                            //  chkAnTreo.Checked = true;
                            chk.Checked = true;
                            hddHinhPhatChange.Value = hinhphat.ToString();
                        }
                    }
                    else
                    {
                        objCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                        //chkAnTreo.Checked = false;
                        chk.Checked = false;
                    }
                }
                catch (Exception ex)
                {
                    objCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        CheckBox chkDefaultTrue = (CheckBox)e.Item.FindControl("chkDefaultTrue");
                        chkDefaultTrue.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkDefaultTrue.Checked = (objCT.TF_VALUE == 1) ? true : false;

                        //RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        //rdDefaultTrue.Visible = true;
                        //if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                        //    rdDefaultTrue.SelectedValue = objCT.TF_VALUE.ToString();
                        break;

                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        CheckBox chkTrueFalse = (CheckBox)e.Item.FindControl("chkTrueFalse");
                        chkTrueFalse.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkTrueFalse.Checked = (objCT.TF_VALUE == 1) ? true : false;

                        //RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        //rdTrueFalse.Visible = true;
                        //if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                        //    rdTrueFalse.SelectedValue = objCT.TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : ((Int64)objCT.SH_VALUE).ToString("#,#", cul);
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                }
            }
        }
        #endregion

        #region Update hinh phat bo sung
        void Update_HinhPhatBS(Repeater rpt, Decimal ToiDanhID, Decimal boluatid)
        {
            Boolean IsUpdate = false, IsDelete = false, IsEdit = false;
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lstBS = null;
                    IsUpdate = IsDelete = IsEdit = false;

                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);

                    //KT du lieu co duoc sua ko (ko phải la dl mac dinh empty)
                    IsEdit = GetValue_HPBoSung(obj, itemHP);

                    //KT da co hinhphat bo sung nay trong DB?? 
                    try
                    {

                        lstBS = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.ISCHANGE == 1
                                                                            && x.HINHPHATID == hinhphatid
                                                                            ).ToList();
                        if (lstBS != null && lstBS.Count > 0)
                        {
                            IsUpdate = true;
                            obj = lstBS[0];
                            if (!IsEdit)
                            {
                                //DL bi set ve gia tri default & da co trong db -->Xoa dl
                                IsDelete = true;
                                xoa_by_Id(obj.ID);
                            }
                            else
                            {
                                //cho edit
                                IsUpdate = true;
                            }
                        }
                        else
                        {
                            IsDelete = false;
                            IsUpdate = true;
                            //DL da duoc sua <> default_emty--> cho them moi
                            if (IsEdit)
                                IsUpdate = false;
                        }
                    }
                    catch (Exception ex)
                    {
                        IsDelete = false;
                        IsUpdate = true;
                        //DL da duoc sua <> default_emty--> cho them moi
                        if (IsEdit)
                            IsUpdate = false;
                    }

                    if (IsUpdate == false)
                        obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    if (!IsDelete)
                    {
                        obj.ISCHANGE = 1;
                        obj.DIEULUATID = boluatid;
                        obj.TOIDANHID = ToiDanhID;
                        obj.BANANID = BanAnID;
                        obj.BICANID = Convert.ToDecimal(dropBiCao.SelectedValue);
                        obj.VUANID = VuAnID;
                        IsEdit = GetValue_HPBoSung(obj, itemHP);

                        if (!IsUpdate)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                        dt.SaveChanges();
                    }
                }
                catch (Exception ex) { }
            }
        }

        Boolean GetValue_HPBoSung(AHS_SOTHAM_BANAN_DIEU_CHITIET obj, RepeaterItem itemHP)
        {
            Boolean IsEdit = false;
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;
            obj.ISCHANGE = 1;
            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    // RadioButtonList rdDefaultTrue = (RadioButtonList)itemHP.FindControl("rdDefaultTrue");
                    CheckBox chkDefaultTrue = (CheckBox)itemHP.FindControl("chkDefaultTrue");
                    //if (rdDefaultTrue.SelectedValue == "1")
                    if (chkDefaultTrue.Checked)
                    {
                        IsEdit = true;
                        obj.TF_VALUE = 1;
                    }
                    else obj.TF_VALUE = 0;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    //   RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    CheckBox chkTrueFalse = (CheckBox)itemHP.FindControl("chkTrueFalse");
                    obj.TF_VALUE = (chkTrueFalse.Checked) ? 1 : 0;
                    if (chkTrueFalse.Checked)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = (String.IsNullOrEmpty(txtSohoc.Text)) ? 0 : Convert.ToDecimal(txtSohoc.Text.Replace(".", ""));
                    if (obj.SH_VALUE > 0)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    if ((obj.TG_NAM > 0) || (obj.K_VALUE1 > 0) || (obj.K_VALUE1 > 0))
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    if (obj.K_VALUE1 > 0)
                        IsEdit = true;
                    if (!String.IsNullOrEmpty(obj.K_VALUE2))
                        IsEdit = true;
                    break;
            }
            return IsEdit;
        }
        #endregion
        #endregion

        public void xoa(decimal toidanhid)
        {
            decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            BanAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");

            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.TOIDANHID == toidanhid
                                                          && x.BANANID == BanAnID
                                                          && x.BICANID == BiCanID
                                                        ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET obj in lst)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
            lblThongBaoHP.Text = "";
            lbthongbao.Text = "Xóa thành công!";
        }
        public void xoa_by_Id(decimal CurrID)
        {
            try
            {
                AHS_SOTHAM_BANAN_DIEU_CHITIET obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.ID == CurrID).FirstOrDefault();
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(obj);
                dt.SaveChanges();
            }
            catch (Exception ex) { }

            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
            lblThongBaoHP.Text = "";
            lbthongbao.Text = "Xóa thành công!";
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        #endregion       
        //----------------------------------------------   

        //sự kiện Click Chọn tội danh chính
        protected void btnChonToiDanhChinh_Click(object sender, EventArgs e)
        {
            LoadToiDanhChinh();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "hienPopup();", true);
        }
        protected void LoadToiDanhChinh()
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();

            DataTable tbl = objBL.GetToiDanh_To_TDC(BiCanID, BanAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dgToiDanhChinh.DataSource = tbl;
                dgToiDanhChinh.DataBind();
            }
        }
        protected void btnSaveTDC_OnClick(object sender, EventArgs e)
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal sotham_caotrang_dieuluat_id = 0;
            foreach (RepeaterItem item in dgToiDanhChinh.Items)
            {
                CheckBox chk = item.FindControl("chkLuaChon") as CheckBox;
                if (chk.Checked)
                {
                    HiddenField hd_ID = item.FindControl("hddID_ToiDanh") as HiddenField;
                    sotham_caotrang_dieuluat_id = Convert.ToDecimal(hd_ID?.Value + "");
                }
            }
            if (sotham_caotrang_dieuluat_id > 0)
            {
                var obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.ID == sotham_caotrang_dieuluat_id).FirstOrDefault();
                obj.ISMAIN = 1;
                dt.SaveChanges();

                //set tội danh chính của các cáo trạng khác là 0
                var lstObj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.ID != sotham_caotrang_dieuluat_id && x.BICANID == BiCanID && x.BANANID == BanAnID).ToList();
                if (lstObj != null && lstObj.Count != 0)
                {
                    foreach (var itm in lstObj)
                    {
                        if (itm.ISMAIN == 1)
                        {
                            itm.ISMAIN = 0;
                            dt.SaveChanges();
                        }
                    }
                }
            }
            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Chọn tội danh chính thành công!");
            LoadDsToiDanhByBiCan();
            Cls_Comon.SetFocus(this, this.GetType(), btnChonToiDanhChinh.ClientID);
        }

        protected bool CheckToiDanh(object val)
        {
            return val != null && val.ToString() == "1";
        }

        protected void LoadBtnChonTDC()
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);

            var caotrang_dieuluat_ds = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID && x.BANANID == BanAnID);
            if (caotrang_dieuluat_ds.Count() == 0)
                btnChonToiDanhChinh.Visible = false;
            else
                btnChonToiDanhChinh.Visible = true;
        }
    }
}