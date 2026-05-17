using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL.GSTP;
namespace BL.GSTP.BANGSETGET
{
        public class TreeviewNode_toaan
        {
            private String _ID;
            private String _PARENT_ID;
            private String _TEXT;

            public TreeviewNode_toaan()
            {
            }
            public TreeviewNode_toaan(String ID, String PARENT_ID, String TEXT)
            {
                _ID = ID;
                _PARENT_ID = PARENT_ID;
                _TEXT = TEXT;
            }
            public String ID
            {
                get
                {
                    return _ID;
                }
                set
                {
                    _ID = value;
                }
            }
            public String PARENT_ID
            {
                get
                {
                    return _PARENT_ID;
                }
                set
                {
                    _PARENT_ID = value;
                }
            }
            public String TEXT
            {
                get
                {
                    return _TEXT;
                }
                set
                {
                    _TEXT = value;
                }
            }
            public List<TreeviewNode_toaan> get_DM_DONVI_Node(List<DM_TOAAN> nodes)
            {
                List<TreeviewNode_toaan> r = new List<TreeviewNode_toaan>();
                foreach (DM_TOAAN n in nodes)
                {
                TreeviewNode_toaan tn = new TreeviewNode_toaan(n.ID.ToString(), n.CAPCHAID.ToString(), n.TEN);
                    r.Add(tn);
                }
                return r;
            }
        }
   
}