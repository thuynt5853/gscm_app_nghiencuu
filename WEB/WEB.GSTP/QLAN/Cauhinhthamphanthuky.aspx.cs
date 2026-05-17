using BL.GSTP;
using BL.GSTP.QLAN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN
{
    public partial class Cauhinhthamphanthuky : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDataThamPhan();
                LoadDataThuKy();
                LoadGrid();
            }
        }
        private void LoadDataThamPhan()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            var Data = GetListData();
            foreach (DataRow item in oCBDT.Rows)
            {
                if (Data.Count(s=>s.THAMPHAMID==(decimal)item[0])>0)
                {
                    item.Delete();
                }
            }
            oCBDT.AcceptChanges();
            drThamPhan.DataSource = oCBDT;
            drThamPhan.DataTextField = "HOTEN";
            drThamPhan.DataValueField = "ID";
            drThamPhan.DataBind();
        }
        private void LoadDataThuKy()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
            if (oCBDT != null)
            {
                if (oCBDT.Rows.Count > 0)
                {
                    
                    drThuky.DataSource = oCBDT;
                    drThuky.DataTextField = "HOTEN";
                    drThuky.DataValueField = "ID";
                    drThuky.DataBind();
                    drThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                }
            }

        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            CAUHINH_THAMPHAN_THUKY obj = new CAUHINH_THAMPHAN_THUKY();
            lbthongbao.Text = "";
            var ThamPhanId = Convert.ToDecimal(drThamPhan.SelectedValue);
            var ThuKyId = Convert.ToDecimal(drThuky.SelectedValue);
            if (hddid.Value == "" || hddid.Value == "0")
            {
                obj.THAMPHAMID = ThamPhanId;
                obj.THUKYID = ThuKyId;
                obj.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.CAUHINH_THAMPHAN_THUKY.Add(obj);
                dt.SaveChanges();
                lbthongbao.Text = "Thêm mới thành công!";
            }
            else
            { //sua
              //lấy ra thông tin theo cái id vần sửa
                decimal _id = Convert.ToDecimal(hddid.Value);
                obj = dt.CAUHINH_THAMPHAN_THUKY.Where(x => x.ID == _id).FirstOrDefault();
                if (obj == null) return;


                obj.THAMPHAMID = ThamPhanId;
                obj.THUKYID = ThuKyId;
                dt.SaveChanges();
                hddid.Value = _id + "";
                lbthongbao.Text = "Lưu thành công!";
            }
            dgList.CurrentPageIndex = 0;
            LoadDataThamPhan();
            LoadGrid();
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                LoadDataThamPhan();
                drThuky.SelectedIndex = 0;
                hddid.Value = "0";
                IdSelect = 0;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private List<CAUHINH_THAMPHAN_THUKYINFO> GetListData()
        {
            var donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            List<CAUHINH_THAMPHAN_THUKYINFO> lst = (from c in dt.CAUHINH_THAMPHAN_THUKY
                                                    where c.DONVIID== donviID
                                                    select new CAUHINH_THAMPHAN_THUKYINFO
                                                    {
                                                        ID = c.ID,
                                                        THAMPHAMID = c.THAMPHAMID,
                                                        THUKYID = c.THUKYID,
                                                        NGAYSUA = c.NGAYSUA,
                                                        NGAYTAO = c.NGAYTAO,
                                                        NGUOISUA = c.NGUOISUA,
                                                        NGUOITAO = c.NGUOITAO,
                                                        DONVIID = c.DONVIID,
                                                    }).ToList() ?? new List<CAUHINH_THAMPHAN_THUKYINFO>();
            return lst;
        }    
        public void LoadGrid()
        {
            var donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //List<DM_DATAGROUP> lst = dt.CAUHINH_THAMPHAM_THUKY.Where(x => x.tha == txttimkiem.Text || x.TEN.Contains(txttimkiem.Text)).ToList();
            List<CAUHINH_THAMPHAN_THUKYINFO> lst = (from c in dt.CAUHINH_THAMPHAN_THUKY
                                                    where c.DONVIID == donviID
                                                    select new CAUHINH_THAMPHAN_THUKYINFO
                                                    {
                                                        ID = c.ID,
                                                        THAMPHAMID = c.THAMPHAMID,
                                                        THUKYID = c.THUKYID,
                                                        NGAYSUA = c.NGAYSUA,
                                                        NGAYTAO = c.NGAYTAO,
                                                        NGUOISUA = c.NGUOISUA,
                                                        NGUOITAO = c.NGUOITAO,
                                                        DONVIID = c.DONVIID,
                                                        THAMPHAN = dt.DM_CANBO.FirstOrDefault(s => s.ID == c.THAMPHAMID).HOTEN,
                                                        THUKY = dt.DM_CANBO.FirstOrDefault(s => s.ID == c.THUKYID).HOTEN,
                                                    }).ToList() ?? new List<CAUHINH_THAMPHAN_THUKYINFO>();
            if (!string.IsNullOrEmpty(txttimkiem.Text))
            {
                lst = lst.Where(s => s.THAMPHAN.Contains(txttimkiem.Text) || s.THUKY.Contains(txttimkiem.Text)).ToList();
            }
            if (lst != null && lst.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(lst.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + lst.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = lst;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }

        public void xoa(decimal id)
        {

            CAUHINH_THAMPHAN_THUKY oT = dt.CAUHINH_THAMPHAN_THUKY.Where(x => x.ID == id).FirstOrDefault();
            dt.CAUHINH_THAMPHAN_THUKY.Remove(oT);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            dgList.CurrentPageIndex = 0;
            LoadDataThamPhan();
            LoadGrid();
            lbthongbao.Text = "Xóa thành công!";
        }
        public decimal IdSelect = 0;
        public void loadedit(decimal ID)
        {
            
            CAUHINH_THAMPHAN_THUKY oT = dt.CAUHINH_THAMPHAN_THUKY.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            
            string strThamPhan = dt.DM_CANBO.FirstOrDefault(s => s.ID == oT.THAMPHAMID).HOTEN;
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            var Data = GetListData();
            
            foreach (DataRow item in oCBDT.Rows)
            {
                if (Data.Count(s => s.THAMPHAMID == (decimal)item[0] && s.THAMPHAMID!= oT.THAMPHAMID) > 0)
                {
                    item.Delete();
                }
            }
            oCBDT.AcceptChanges();
            IdSelect = oT.THAMPHAMID.Value;
            drThamPhan.DataSource = oCBDT;
            drThamPhan.DataTextField = "HOTEN";
            drThamPhan.DataValueField = "ID";
            drThamPhan.DataBind();

            //drThamPhan.SelectedIndex = (int)oT.THAMPHAMID.Value;
            drThuky.SelectedIndex = drThuky.Items.IndexOf(drThuky.Items.FindByValue(oT.THUKYID.Value.ToString()));
        }
        protected void ddlPopulation_DataBound(object sender, EventArgs e)
        {
            if (IdSelect>0)
            {
                drThamPhan.SelectedIndex = drThamPhan.Items.IndexOf(drThamPhan.Items.FindByValue(IdSelect.ToString())); 
                
            }
        }
        string s = "";
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal donvi_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    loadedit(donvi_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    xoa(donvi_id);
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

        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            LoadGrid();
        }
    }
}