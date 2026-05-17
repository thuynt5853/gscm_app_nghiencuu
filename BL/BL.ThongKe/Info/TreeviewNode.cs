using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BL.THONGKE.Info;

namespace BL.ThongKe.Info
{
    public class TreeviewNode
    {
        private String _ID;
        private String _PARENT_ID;
        private String _TEXT;

        public TreeviewNode()
        {
        }
        public TreeviewNode(String ID, String PARENT_ID, String TEXT)
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

        public List<TreeviewNode> getCourtsNode(List<Courts> nodes)
        {
            List<TreeviewNode> r = new List<TreeviewNode>();
            foreach (Courts n in nodes)
            {
                TreeviewNode tn = new TreeviewNode(n.ID.ToString(), n.PARENT_ID.ToString(),n.COURT_NAME);
                r.Add(tn);
            }
            return r;
        }

        public List<TreeviewNode> getChaptersNode(List<Chapters> nodes)
        {
            List<TreeviewNode> r = new List<TreeviewNode>();
            foreach (Chapters n in nodes)
            {
                TreeviewNode tn = new TreeviewNode(n.ID.ToString(), n.TIMES.ToString(), n.CHAPER_NAME);
                r.Add(tn);
            }
            return r;
        }

        public List<TreeviewNode> getCasesNode(List<Cases> nodes)
        {
            List<TreeviewNode> r = new List<TreeviewNode>();
            foreach (Cases n in nodes)
            {
                TreeviewNode tn = new TreeviewNode(n.ID.ToString(), n.PARENT_ID.ToString(), n.CASE_NAME);
                r.Add(tn);
            }
            return r;
        }

        public List<TreeviewNode> getCriminalsNode(List<Criminals> nodes)
        {
            List<TreeviewNode> r = new List<TreeviewNode>();
            foreach (Criminals n in nodes)
            {
                TreeviewNode tn = new TreeviewNode(n.ID.ToString(), n.CHAPTER_ID.ToString(), n.CRIMINAL_NAME);
                r.Add(tn);
            }
            return r;
        }

        public List<TreeviewNode> getFunctionNode(List<Functions> nodes)
        {
            List<TreeviewNode> r = new List<TreeviewNode>();
            foreach (Functions n in nodes)
            {
                TreeviewNode tn = new TreeviewNode(n.ID.ToString(), n.ID_PARENT.ToString(), n.FUNCTION_NAME);
                r.Add(tn);
            }
            return r;
        }
    }
}