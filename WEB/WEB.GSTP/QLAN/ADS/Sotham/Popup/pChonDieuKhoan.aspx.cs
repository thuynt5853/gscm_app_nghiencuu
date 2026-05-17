using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ADS.Sotham.Popup
{
    public partial class pChonDieuKhoan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal DonID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        #region METHOD
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    DonID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                    if (DonID > 0)
                    {
                        LoadDrop();
                        try
                        {
                            if (Request["bID"] != null)
                                dropBoLuat.SelectedValue = Request["bID"] + "";
                        }
                        catch { }
                        CheckQuyen();
                        LoadGrid();
                    }
                    else
                        Response.Redirect("/Login.aspx");
                } catch (Exception ex)
                {
                    lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                    logger.Error("loi xay ra: " + ex);
                }
            }
        }

        /// <summary>
        /// check quyền
        /// </summary>
        void CheckQuyen()
        {
            ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DonID).FirstOrDefault();
            int MAGIAIDOAN = Convert.ToInt16(oT.MAGIAIDOAN);
            if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lbthongbao.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                cmdSave.Visible = cmdSave2.Visible = false;
                return;
            }
            else if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                cmdSave.Visible = cmdSave2.Visible = false;
                return;
            }
            //string StrMsg = "Không được sửa đổi thông tin.";
            //string Result = new ADS_CHUYEN_NHAN_AN().Check_NhanAn(VuAnID, StrMsg);
            //if (Result != "")
            //{
            //    lbthongbao.Text = Result;
            //    Cls_Comon.SetButton(cmdSave, false);
            //    Cls_Comon.SetButton(cmdSave2, false);
            //    return;
            //}
        }

        /// <summary>
        /// load drop down list bộ luật
        /// </summary>
        void LoadDrop()
        {
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.LOAI == ENUM_LOAIVUVIEC.AN_DANSU && x.HIEULUC == 1 && x.LOAI != "01")
                .OrderByDescending(y => y.NGAYBANHANH).ToList();
            dropBoLuat.Items.Clear();
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }

        void ThemMoi(string strtoidanhid)
        {
            DonID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            decimal toidanhid = Convert.ToDecimal(strtoidanhid);

            String[] arrToiDanh = null;
            DM_BOLUAT_TOIDANH objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
            arrToiDanh = objTD.ARRSAPXEP.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh(DonID, toidanhid);
                    }
                }
                dt.SaveChanges();
            }
        }

        void InsertToiDanh(Decimal DonID, Decimal toidanhid)
        {
            bool isupdate = false;
            DM_BOLUAT_TOIDANH objTD = null;
            ADS_SOTHAM_BANAN_DIEULUAT obj = new ADS_SOTHAM_BANAN_DIEULUAT();
            try
            {
                obj = dt.ADS_SOTHAM_BANAN_DIEULUAT.Where(x => x.DONID == DonID && x.DIEULUATID == toidanhid)
                        .Single<ADS_SOTHAM_BANAN_DIEULUAT>();
                if (obj != null)
                    isupdate = true;
                else
                    obj = new ADS_SOTHAM_BANAN_DIEULUAT();
            }
            catch (Exception ex) { obj = new ADS_SOTHAM_BANAN_DIEULUAT(); }
            if (!isupdate)
            {
                obj.DONID = DonID;
                //obj.DIEULUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
                obj.DIEULUATID = Convert.ToDecimal(toidanhid);

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                //update 14082025
                if (obj.TOA_GIAIQUYET_ID == null) obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.ADS_SOTHAM_BANAN_DIEULUAT.Add(obj);
            }
        }

        void XoaItem(string DelItem)
        {
            DonID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            decimal boluatid = 0, toidanhid = 0;
            string[] arr_child = null;
            string[] arr = DelItem.Split("|".ToArray());

            ADS_SOTHAM_BANAN_DIEULUAT obj = null;
            foreach (String item in arr)
            {
                if (item.Length > 0)
                {
                    //arr_child = item.Split(";".ToCharArray());
                    //boluatid = Convert.ToDecimal(arr_child[0] + "");
                    //toidanhid = Convert.ToDecimal(arr_child[1] + "");
                    toidanhid = Convert.ToDecimal(item);

                    List<ADS_SOTHAM_BANAN_DIEULUAT> lst = dt.ADS_SOTHAM_BANAN_DIEULUAT
                                                            .Where(x => x.DONID == DonID && x.DIEULUATID == toidanhid)
                                                            .ToList<ADS_SOTHAM_BANAN_DIEULUAT>();
                    if (lst.Count > 0)
                    {
                        obj = lst.Single<ADS_SOTHAM_BANAN_DIEULUAT>();
                        dt.ADS_SOTHAM_BANAN_DIEULUAT.Remove(obj);
                        dt.SaveChanges();
                    }
                }
            }
        }

        void GetOldChange()
        {
            string OldChange = "|";
            string temp = "|";
            Decimal DonID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            
            List<ADS_SOTHAM_BANAN_DIEULUAT> lst = null;
            lst = dt.ADS_SOTHAM_BANAN_DIEULUAT.Where(x => x.DONID == DonID).ToList<ADS_SOTHAM_BANAN_DIEULUAT>();
            if (lst != null && lst.Count > 0)
            {
                foreach (ADS_SOTHAM_BANAN_DIEULUAT obj in lst)
                    OldChange += obj.DIEULUATID + "|";
                hddOld.Value = OldChange;

                foreach (RepeaterItem item in rpt.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                    temp = "|" + hddToiDanhID.Value + "|";
                    if (hddOld.Value.Contains(temp))
                        chk.Checked = true;
                    else chk.Checked = false;
                }
            }
        }

        public void LoadGrid()
        {
            string tentoidanh = txtTenToiDanh.Text.Trim();
            int hieuluc = 1;
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_DANSU);

            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            string diem = txtDiem.Text.Trim();
            string khoan = txtKhoan.Text.Trim();
            string dieu = txtDieu.Text.Trim();
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByLuatID_NoChuong_Paging(luatid, tentoidanh, diem, khoan, dieu, hieuluc, pageindex, pagesize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;

                GetOldChange();
            }
            else
            {
                pndata.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        #endregion

        #region EVENT
        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdSave_Click(object sender, EventArgs e)
        {
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            String OldChange = hddOld.Value;
            string temp = "";
            String DelItem = "|";
            foreach (RepeaterItem item in rpt.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chk");
                HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                temp = "|" + hddToiDanhID.Value + "|";
                if (!string.IsNullOrEmpty(OldChange))
                {
                    if (OldChange.Contains(temp))
                    {
                        if (!chk.Checked)
                            DelItem += hddToiDanhID.Value + "|";
                    }
                    else
                    {
                        if (chk.Checked)
                            ThemMoi(hddToiDanhID.Value);
                    }
                }
                else
                {
                    if (chk.Checked)
                        ThemMoi(hddToiDanhID.Value);
                }
            }
            if ((!string.IsNullOrEmpty(DelItem)) && (DelItem != "|"))
                XoaItem(DelItem);
            
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }

        #region Phân trang
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        #endregion
    }
}