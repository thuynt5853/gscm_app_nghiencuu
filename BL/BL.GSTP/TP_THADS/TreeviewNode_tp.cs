using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL.GSTP;
namespace BL.GSTP.TP_THADS
{
        public class TreeviewNode_tp
        {
            private String _ID;
            private String _PARENT_ID;
            private String _TEXT;

            public TreeviewNode_tp()
            {
            }
            public TreeviewNode_tp(String ID, String PARENT_ID, String TEXT)
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
            public List<TreeviewNode_tp> get_DM_DONVITHIHANHAN_Node(List<DM_DONVITHIHANHAN> nodes)
            {
                List<TreeviewNode_tp> r = new List<TreeviewNode_tp>();
                foreach (DM_DONVITHIHANHAN n in nodes)
                {
                    TreeviewNode_tp tn = new TreeviewNode_tp(n.ID.ToString(), n.CAPCHAID.ToString(), n.TEN);
                    r.Add(tn);
                }
                return r;
            }
        }
   
}